#!/usr/bin/env bash
#
##########################################
# Basic Info:
# Global constants that are needed by the assistant services shell scripts.
# Requires: $FILE_DIR
##########################################

# Colors
NC='\033[0m'
RED='\e[01;31m'
GREEN='\e[92m'
YELLOW='\e[1;93m'

# Directories of where the os services should be placed
OS_SERVICES_DIR=/etc/systemd/system
OS_USER_SERVICES_DIR=~/.config/systemd/user

# The directory of the current file
GLOBALS_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# The main directory of the project
MAIN_PROJECT_DIR=$(echo "$GLOBALS_FILE_DIR" | awk -F/services/helpers '{print $1}')

# The assistant package dir
PROJECT_CODES_DIR="$MAIN_PROJECT_DIR"/assistant

PROJECT_SERVICES_DIR="$MAIN_PROJECT_DIR"/services

PROJ_SERVICES_DIR="$PROJECT_SERVICES_DIR/system_services"
PROJ_USER_SERVICES_DIR="$PROJECT_SERVICES_DIR/user_services"

# Names of services files
SERVICES_NAMES=$(ls "$PROJ_SERVICES_DIR" | grep -F .service)
USER_SERVICES_NAMES=$(ls "$PROJ_USER_SERVICES_DIR" | grep -F .service)