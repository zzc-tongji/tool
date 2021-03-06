#!/bin/sh

if command -v docker >/dev/null 2>&1; then
  docker run --name qcZh3AkmKOs8Byux -it ubuntu:20.04 apt-get update && apt-get install wget -y && wget -qO- https://raw.githubusercontent.com/ernisn/superspeed/master/superspeed.sh > superspeed.sh && chmod +x superspeed.sh && ./superspeed.sh
  docker container rm qcZh3AkmKOs8Byux
else
  echo '(docker: not installed, could be installed by `wget -qO- https://get.docker.com/ | sh`)'
  echo
fi
