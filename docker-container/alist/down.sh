#!/bin/sh
set -x

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# stop
sudo docker compose stop

# delete
sudo docker compose down

# clean log file(s)
rm -fr ./mount/data/log
rm -fr ./mount/data/temp
