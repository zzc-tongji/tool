#!/bin/sh

# work directory
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_PATH

# loop
while :
do
  # wait
  sleep 60s

  # [frpc 服务]
  #
  # systemctl -l --no-pager status [frpc 服务] >/dev/null 2>&1
  ./tcping [映射 IP] [映射 TCP 端口号] -u 1000000 -q
  if [ $? -ne 0 ]; then
    systemctl restart [frpc 服务]
    echo "`date '+%Y-%m-%d %H:%M:%S %Z'` => [frpc 服务]"
  fi
done
