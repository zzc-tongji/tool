#!/bin/sh

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# disable
SERVICE_NAME=`basename $SCRIPT_PATH`
if [ -f /etc/systemd/system/"$SERVICE_NAME".service ]; then
  systemctl disable "$SERVICE_NAME"
fi
echo service ["$SERVICE_NAME"] disabled
