#!/bin/sh
set -ex

# check termux
if [ -z $TERMUX_APP_PID ]; then
  echo "The script can only be executed in Termux."
  exit 1
fi


# config termux boot
mkdir -p $HOME/.termux/boot
echo '#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sshd
. $PREFIX/etc/profile' > $HOME/.termux/boot/start.sh
chmod +x $HOME/.termux/boot/start.sh # https://wiki.termux.com/wiki/Termux:Boot

# install package
pkg upgrade
pkg install build-essential
pkg install git
pkg install net-tools
pkg install openssh
pkg install termux-api # https://wiki.termux.com/wiki/Termux:API
pkg install termux-services
pkg install vim
pkg install wget
pkg install zsh

# get tool
cd $HOME
git clone https://github.com/zzc-tongji/tool tool

# config zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo '

#
# appended by owner
#

export PATH=$HOME/tool/bin/Linux/arm64:$HOME/tool/script/Linux:$PATH
. $HOME/.termux/boot/start.sh

#
# appended by others
#
' >> $HOME/.zshrc
cp -f $HOME/config/Linux/.gitconfig $HOME/.gitconfig
cp -f $HOME/tool/config/Linux/.vimrc $HOME/.vimrc

# show user
echo 'Termux linux user is "'$(whoami)'".'
echo "Succeed."
