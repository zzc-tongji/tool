#!/bin/sh

echo
if command -v ifconfig >/dev/null 2>&1; then
  ifconfig
else
  echo '(ifconfig: not installed, could be installed by `apt-get install net-tools`)'
  echo
fi
#
if command -v netstat >/dev/null 2>&1; then
  netstat -tunlp
else
  echo '(netstat: not installed, could be installed by `apt-get install net-tools`)'
fi
echo
#
if command -v docker >/dev/null 2>&1; then
  DOCKER_CONTAINER_ID_LIST=`docker ps -aq`
  if [ ${#DOCKER_CONTAINER_ID_LIST} -ne 0 ]; then
    docker inspect -f '{{.NetworkSettings.Ports}} => {{.Name}}' $DOCKER_CONTAINER_ID_LIST
    echo
  fi
else
  echo '(docker: not installed, could be installed by `wget -qO- https://get.docker.com/ | sh`)'
  echo
fi
#
if command -v firewall-cmd >/dev/null 2>&1; then
  firewall-cmd --list-all
else
  echo '(firewall-cmd: not installed, could be installed by `apt-get install firewalld`)'
fi
echo
#
curl -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36" https://ifconfig.co/json
echo
