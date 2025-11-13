#!/bin/sh
set -x

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# stop
sudo docker compose stop

# clean log file(s)
sudo rm -fr ./mount/log
