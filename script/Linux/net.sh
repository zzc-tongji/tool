#!/bin/sh

SUDO="sudo"
([ $TERMUX_APP_PID ] || [ `whoami` = "root" ]) && SUDO=""
#
echo
if command -v ip address show >/dev/null 2>&1; then
  ip address show
else
  echo '(ip: not installed, could be installed by `apt-get install iproute2`)'
  echo
fi
#
if command -v ip route show >/dev/null 2>&1; then
  ip route show
else
  echo '(ip: not installed, could be installed by `apt-get install iproute2`)'
  echo
fi
#
if command -v ss >/dev/null 2>&1; then
  $SUDO ss -tunlp
else
  echo '(ss: not installed, could be installed by `apt-get install iproute2`)'
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
