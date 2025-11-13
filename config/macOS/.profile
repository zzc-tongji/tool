# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
  fi
fi

# if running zsh
if [ -n "$ZSH_VERSION" ]; then
  # include .zshrc if it exists
  if [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

#
# appended by owner
#

# set path so it includes bin/script from repo "https://github.com/zzc-tongji/tool" if it exists
TOOL_REPO="$HOME/tool"
if [ -d "$TOOL_REPO" ]; then
  ARCH="amd64"
  case "$(uname -m)" in
    "aarch64")
      ARCH="arm64"
      ;;
    "arm64")
      ARCH="arm64"
      ;;
    "x86_64")
      ARCH="amd64"
    ;;
  esac
  PATH="$TOOL_REPO/bin/macOS/$ARCH:$TOOL_REPO/script/macOS:$PATH"
  unset ARCH
else
  unset TOOL_REPO
fi

#
# appended by others
#

# nvm
NVM_DIR="$HOME/.config/nvm"
if [ -d "$NVM_DIR" ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
else
  unset NVM_DIR
fi

# conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
CONDA_DIR="$HOME/miniconda3"
if [ -d "$CONDA_DIR" ]; then
  __conda_setup=`"$CONDA_DIR/bin/conda" 'shell.zsh' 'hook' 2> /dev/null`
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]; then
      . "$CONDA_DIR/etc/profile.d/conda.sh"
    else
      PATH="$CONDA_DIR/bin:$PATH"
    fi
  fi
  unset __conda_setup
else
  unset CONDA_DIR
fi
# <<< conda initialize <<<

