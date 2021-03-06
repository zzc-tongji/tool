#!/bin/sh

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# enable
SERVICE_NAME=`basename $SCRIPT_PATH`
ln -s "$SCRIPT_PATH"/"$SERVICE_NAME".service /etc/systemd/system/"$SERVICE_NAME".service 2>/dev/null
if [ $? -eq 0 ]; then
  systemctl daemon-reload
  systemctl enable "$SERVICE_NAME"
fi
echo service ["$SERVICE_NAME"] enabled
