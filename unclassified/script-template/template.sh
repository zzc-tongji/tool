#!/bin/sh
set -eu

# --- args validation ---
if [ "$#" -lt 0 ]; then # FIXME: replace with real check
  echo "Usage: $0 <args>"
  exit 1
fi
# -----------------------

START_PWD="${PWD}"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)

cleanup() {
  # Add teardown logic here (runs on both success and failure)
  cd "${START_PWD}"
}
trap cleanup EXIT

# --- your code here ---
cd "${SCRIPT_DIR}"
# ----------------------

exit 0
