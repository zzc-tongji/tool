#!/bin/sh
set -eux

# start pwd & script dir
START_PWD=${PWD}
SHELL_NAME=`ps -p $$ | awk 'NR==2{print $4}'`
if [ "${SHELL_NAME}" = "zsh" ]; then
  SCRIPT_DIR=`cd "$(dirname "${(%):-%N}")"; pwd -P`
elif [ "${SHELL_NAME}" = "bash" ] || [ "${SHELL_NAME}" = "sh" ]; then
  SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE}")"; pwd -P`
else
  SCRIPT_DIR=`cd "$(dirname "$0")"; pwd -P`
fi

# finally
function finally {
  #
  # Do something at the end of the script
  # regardless of success or failure.
  #
}
trap finally EXIT

#
# Do something.
#

# exit
exit 0
