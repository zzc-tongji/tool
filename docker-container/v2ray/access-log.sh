#!/bin/sh
set -x

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# log
sudo tail -f ./mount/log/access.log
