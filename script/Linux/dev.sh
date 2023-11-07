#!/bin/sh

# run
# curl -L dev-sh.zzc.icu | sh

# prepare
set -e
set -u
set -x

# time
LOCALTIME="/etc/localtime"
if [ -f $LOCALTIME ]; then
  cp -f $LOCALTIME "$LOCALTIME.backup"
  rm -f $LOCALTIME
fi
ln -s /usr/share/zoneinfo/UTC $LOCALTIME
ln -fs $LOCALTIME

# package
if [ $(cat /etc/os-release | grep -ci "debian\|ubuntu") -gt 0 ]; then
  apt-get --yes update
  apt-get --yes upgrade
  apt-get --yes install at
  apt-get --yes install cron
  apt-get --yes install build-essential
  apt-get --yes install curl
  apt-get --yes install git
  apt-get --yes install net-tools
  apt-get --yes install rsync
  apt-get --yes install vim
  apt-get --yes install wget
elif [ $(cat /etc/os-release | grep -ci "redhat\|centos\|fedora\|suse") -gt 0 ]; then
  yum -y update
  yum -y upgrade
  yum -y install at
  yum -y install cronie
  yum -y groupinstall "Development Tools"
  yum -y install curl
  yum -y install git
  yum -y install net-tools
  yum -y install rsync
  yum -y install vim
  yum -y install wget
else
  echo "[Error] unsupported linux distribution"
  exit 1
fi

# docker
curl -sSL https://get.docker.com/ | sh
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# variable
ARCH=$(uname -m)
HOME=$(env | grep ^HOME= | cut -c 6-)
BIN="$HOME/bin"
HOSTNAME="/etc/hostname"
DATE=$(date "+%Y%m%d-%H%M%S")
REPO_PATH="/tmp/tool-$DATE"
SSH="$HOME/.ssh"
SSHD_CONFIG="/etc/ssh/sshd_config"
cd $HOME

# hostname
cp -f $HOSTNAME "$HOSTNAME.backup"
set +e
curl -sSL https://ifconfig.me/ > $HOSTNAME && echo >> $HOSTNAME
if [ $? -eq 0 ]; then
  sed -i 's/\./-/g' $HOSTNAME
fi
set -e
ln -fs $HOSTNAME

# ssh
cp -f $SSHD_CONFIG "$SSHD_CONFIG.backup"
sed -i 's/#Port 22/Port 22/g' $SSHD_CONFIG
sed -i 's/Port 22/Port 60000/g' $SSHD_CONFIG
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/g' $SSHD_CONFIG
sed -i 's/\/usr\/lib\/openssh\/sftp-server/\/usr\/lib\/openssh\/sftp-server -u 0022/g' $SSHD_CONFIG
ln -fs $SSHD_CONFIG
mkdir -p $SSH
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN3n8E9EsTRn763uz2NkHzr+reUKJMlqc87qU5fveTZ/geUv74RevpaUctJAReuq8mK8wDafwzntQSJUd+k+JA7NtoAvyHGM+tu/I7tKBJKAab2l02/C2m4HWf2Hl2BeJkjobWi/HvZs2ns6bSGQyEiiaj3+K2xl9gBI1ZSL7a5lq4OD9/YKVlHzYwgOZcuUgFgnN2UwqY7kJfxbrL87nZzrJjX2Fqy1xaWsZVUwNTVpHaBsA1NFM/4NKBcFgrMf2EzvwguxYMeHxnFA0iXVDWSXMmI+fgGAIp2SNWT1FlpFSxJGMusbpzW2BCjEl0B3CFexOneONeg0pmMZqt5nzETw3RBpmkBB55/EKl6cJRQngQYnRlJn3xxc+Vf6dUxBXtrE1qFRNNr+ofQdcBoRvOIQvrRFi+XbdLKoePPohHGwRYZKa37MrcYv5AkIqb16OzC3TSPWg5TCRA//UfJgt/okVTiZBAW3gNnoD8IqDSkwNpSma7K8oqfZiogw1KN4b2Fv86pizdjyqupKe9NYFrLA53bgtg24VaToCWVKR0Y1Ia/Caf7/QWhXIuUZGMC0Io19lA9QC04J5bjWK6uuc9oKGVYGY1zVlLgsXwSvByLSpSAWM/N/YS8nMWHjV4nQOxLDs5lCcSXQhNvSqRirbkb2S+kwgGrpCQI6c9UsGQ+w== dev" >> "$SSH/authorized_keys"
chmod 600 "$SSH/authorized_keys"
set +e
systemctl stop firewalld
systemctl disable firewalld
set -e

# bin
git clone https://github.com/zzc-tongji/tool.git $REPO_PATH
mkdir -p $BIN
if [ $ARCH == "x86_64" ]; then
  set +e
  cp -f $REPO_PATH/bin/Linux/amd64/* $BIN/
  cp -f $REPO_PATH/bin/Linux/amd64/.[^.]* $BIN/
  set -e
fi

# script
set +e
cp -f $REPO_PATH/script/Linux/* $BIN/
cp -f $REPO_PATH/script/Linux/.[^.]* $BIN/
set -e
rm -f $BIN/dev.sh
chmod -R 755 $BIN/*

# config
if [ -f $HOME/.bashrc ]; then
  cp -f $HOME/.bashrc "$HOME/.bashrc.backup"
fi
if [ -f $HOME/.profile ]; then
  cp -f $HOME/.profile "$HOME/.profile.backup"
fi
set +e
cp -f $REPO_PATH/config/Linux/* $HOME/
cp -f $REPO_PATH/config/Linux/.[^.]* $HOME/
set -e
rm -fr $REPO_PATH

# node.js
curl -L https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
set +x
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
set -x
npm install yarn -g

# restart
shutdown -r now
