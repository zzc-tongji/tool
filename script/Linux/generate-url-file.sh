#!/bin/sh

set -e
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

if [ -z "$1" ]; then
  echo "URL not set, required."
  exit 1
fi

if [ -z "$2" ]; then
  echo '[InternetShortcut]'
  echo "URL=$1"
else
  echo '[InternetShortcut]' > "$2"
  echo "URL=$1" >> "$2"
fi
