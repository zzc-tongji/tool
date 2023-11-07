#
# appended by owner
#

# alias
alias ll='ls -alh'
alias l='ls -lh'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# script
export PATH="$HOME/bin/:$PATH"

# git log enhance
git() {
    if [ "$1" = "log" ]
    then
        # command git log --all --graph "${@:2}";
        command git log --graph "${@:2}";
    else
        command git "$@";
    fi;
}

# anaconda
export PATH="/opt/anaconda3/bin/:$PATH"

# android studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# BFG Repo-Cleaner
alias bfg="java -jar /Applications/bfg-1.13.0.jar"

# user bin
export PATH="$HOME/bin/:$PATH"

#
# appended by others
#

# nvm
export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
