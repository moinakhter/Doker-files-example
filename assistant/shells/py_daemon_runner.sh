#!/usr/bin/env bash
#
##########################################
# Basic Info:
# This bash script will run any given path in a separate python daemon.
# it is typically used to run python script from the system services
# whenever an argument is passed to this shell script the script will try
# to run the python script using the project environment, if the project
# env does not exist, it will run the given python script using the main OS python env.
##########################################
FILE_DIR=$(dirname "$0")
source "$FILE_DIR"/helpers/globals.sh

env="$ENV_PYTHON"
py_script_path=$1


#######################################
# Runs a given python script path in a daemon process.
# Globals:
#   env
#   PROJCET_CODES_DIR
# Arguments:
#   $1 python script path.
#######################################
function python_script_daemon_runner() {
  DIRECTORY="$1"
  MAIN_PY="$MAIN_PROJECT_DIR"/"$DIRECTORY"
  if test -f "$env"; then
    "$env" "$MAIN_PY";
  else
      python3 "$MAIN_PY";
  fi
}

python_script_daemon_runner "$py_script_path"