#!/bin/sh
set -x

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# stop
sudo docker compose stop

# clean log file(s)
sudo rm -fr ./mount/log

# delete
sudo docker compose down

# create log directory
mkdir ./mount/log

# create
sudo docker compose up --detach

# update owner of log file(s)
sudo chown -R zzc:zzc ./mount/log
