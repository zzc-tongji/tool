#!/bin/sh

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# start
SERVICE_NAME=`basename $SCRIPT_PATH`
journalctl -u $SERVICE_NAME -n 30 -f
