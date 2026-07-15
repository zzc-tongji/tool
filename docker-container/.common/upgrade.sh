#!/bin/bash
set -e

# Enter current directory
SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd -P)
cd "$SCRIPT_PATH"

# Collect remote images (skip services with local build)
IMAGES=""
for svc in $(docker compose config --services 2>/dev/null); do
    if docker compose config 2>/dev/null | awk -v svc="$svc" '
        $0 ~ "^  " svc ":"   { in_block=1; next }
        in_block && /^  [a-z]/ { in_block=0 }
        in_block && /build:/   { found=1; exit }
        END { exit !found }
    ' > /dev/null; then
        echo "[skip] $svc: local build"
    else
        img=$(docker compose config 2>/dev/null | awk -v svc="$svc" '
            $0 ~ "^  " svc ":" { in_block=1; next }
            in_block && /^  [a-z]/ { in_block=0 }
            in_block && /image:/ { print $2; exit }
        ')
        if [ -n "$img" ]; then
            IMAGES="$IMAGES $img"
        fi
    fi
done

if [ -z "$IMAGES" ]; then
    echo "No remote images to check"
    exit 0
fi

IMAGES=$(echo "$IMAGES" | tr ' ' '\n' | sort -u)
echo "Checking $(echo "$IMAGES" | wc -l) remote image(s):"
echo "$IMAGES"
echo ""

# Record pre-pull image IDs
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

for img in $IMAGES; do
    docker images --format '{{.ID}}' "$img" 2>/dev/null || echo "NONE"
done > "$TMPDIR/old.txt"

# Pull all
docker compose pull

# Compare
i=1
CHANGED=false
for img in $IMAGES; do
    OLD_ID=$(sed -n "${i}p" "$TMPDIR/old.txt")
    NEW_ID=$(docker images --format '{{.ID}}' "$img" 2>/dev/null || echo "NONE")
    if [ "$OLD_ID" != "$NEW_ID" ]; then
        echo "[changed] $img  ->  $NEW_ID"
        CHANGED=true
    fi
    i=$((i + 1))
done

if ! $CHANGED; then
    echo "All images up to date, nothing to upgrade"
    exit 0
fi

echo ""
echo "Upgrading..."
./rebuild.sh
docker image prune -f
echo "Upgrade complete"
