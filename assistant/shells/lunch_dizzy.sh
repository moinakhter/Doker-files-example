#!/usr/bin/env bash

#this file to lunch all the services with assistant and needs sudo permission
FILE_DIR=$(dirname "$0")
source "$FILE_DIR"/helpers/globals.sh
PROJECT_SERVICES_DIR="$MAIN_PROJECT_DIR"/services
HAS_PERMISSION=$(sudo -l | grep "ALL")

if [ ! -z "$HAS_PERMISSION" ]; then
  cd "$PROJECT_SERVICES_DIR" && bash -l system_services.sh "start"
  cd "$MAIN_PROJECT_DIR" && .venv/bin/python -m assistant
fi
