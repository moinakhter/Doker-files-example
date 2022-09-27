#!/usr/bin/env bash

FILE_DIR=$(dirname "$0")
source "$FILE_DIR"/helpers/globals.sh
HAS_PERMISSION=$(sudo -l | grep "ALL")
MY_PID=$!
EXIT_STATUS=$?
EXECUTION_STATUS=$( echo "$EXIT_STATUS" | grep 0)

if [ ! -z "$HAS_PERMISSION" ]; then
  cd ..
  wait $MY_PID
  if [ "$EXECUTION_STATUS" == 0 ]; then
    cd "$MAIN_PROJECT_DIR" && mkdir -p .venv
    wait $MY_PID
    /usr/local/bin/python3.9 -m pipenv install
    wait $MY_PID
    printf "\n${GREEN}Environment setup completed successfully!${NC}\n"
    exit 0
  else
    printf "${RED}Could not execute try agian!!${NC}\n"
    echo "The exit status of the process was $EXIT_STATUS"
    exit 0
  fi
fi