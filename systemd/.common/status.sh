#!/bin/sh

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# start
SERVICE_NAME=`basename $SCRIPT_PATH`
systemctl -l --no-pager status "$SERVICE_NAME"
