#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo 'parameter $1 required as source disk name'
  exit 1
fi
SRC=$1

if [ -z "$2" ]; then
  echo 'parameter $2 required as destination disk name'
  exit 2
fi
DEST=$2

set -ux
cd /media
sudo rsync -exclude "${SRC}/lost+found" -a --delete --delete-before "${SRC}/" "${DEST}"
exit 0
