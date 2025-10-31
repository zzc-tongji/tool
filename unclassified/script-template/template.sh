#!/bin/sh
set -eux

#
# Add validation of input parameter(s) here.
#
if [ "$#" -lt 0 ]; then
  echo "Usage: $0"
  exit 1
fi

# start pwd & script dir
START_PWD="${PWD}"
SHELL_NAME=`ps -p $$ | awk 'NR==2{print $4}'`
if [ "${SHELL_NAME}" = "zsh" ]; then
  SCRIPT_DIR=`cd "$(dirname "${(%):-%N}")"; pwd -P`
elif [ "${SHELL_NAME}" = "bash" ] || [ "${SHELL_NAME}" = "sh" ]; then
  SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE}")"; pwd -P`
else
  SCRIPT_DIR=`cd "$(dirname "$0")"; pwd -P`
fi

# finally
finally () {
  #
  # Do something at the end of the script
  # regardless of success or failure.
  #
  cd "${START_PWD}"
}
trap finally EXIT

#
# Do something.
#
cd "${SCRIPT_DIR}"

# exit
exit 0
