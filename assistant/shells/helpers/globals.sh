#!/usr/bin/env bash
#
##########################################
# Basic Info:
# This bash script will give a general information about the project directory and environment.
# It is intended to be used as a helper shell for other shell scripts.
##########################################

# Colors
NC='\033[0m'
RED='\e[01;31m'
GREEN='\e[92m'
YELLOW='\e[1;93m'

# The directory of the current file
FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# The main directory of the project
MAIN_PROJECT_DIR=$(echo "$FILE_DIR" | awk -F/shells/helpers '{print $1}')

# The assistant package dir
PROJCET_CODES_DIR="$MAIN_PROJECT_DIR"/assistant

# Pipenv python dir
ENV_PYTHON="$MAIN_PROJECT_DIR"/.venv/bin/python

