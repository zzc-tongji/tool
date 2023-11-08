#!/bin/sh

SUDO="sudo"
([ $TERMUX_APP_PID ] || [ `whoami` = "root" ]) && SUDO=""
#
echo
if command -v ifconfig >/dev/null 2>&1; then
  ifconfig
else
  echo '(ifconfig: not installed, could be installed by `apt-get install net-tools`)'
  echo
fi
#
ip route show
echo
#
if command -v netstat >/dev/null 2>&1; then
  $SUDO netstat -tunlp
else
  echo '(netstat: not installed, could be installed by `apt-get install net-tools`)'
fi
echo
#
if command -v docker >/dev/null 2>&1; then
  DOCKER_CONTAINER_ID_LIST=`$SUDO docker ps -aq`
  if [ ${#DOCKER_CONTAINER_ID_LIST} -ne 0 ]; then
    $SUDO docker inspect -f "{{.NetworkSettings.Ports}} => {{.Name}}" $DOCKER_CONTAINER_ID_LIST
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
IP_QUERY_URL="https://ifconfig.me/"
echo "Public IPv4 : "`curl --silent $IP_QUERY_URL`
WARP="`curl --silent --proxy socks5://127.0.0.1:40000/ $IP_QUERY_URL`"
if [ "$WARP" != "" ]; then
  echo "  WARP IPv4 : $WARP"
fi
echo
