#!/bin/sh
set -x

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# restart
sudo docker compose restart

# comfirm whether started or not
sleep 5
sudo docker compose logs --tail 20
