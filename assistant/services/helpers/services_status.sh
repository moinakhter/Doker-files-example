#!/usr/bin/env bash
#
##########################################
# Basic Info:
# This shell file will give the status of all the OS services related to the assistant or it can return the status of
# the provided service name only.
# Use samples:
# ./services_status.sh
# ./services_status.sh assistant-face-local-run
##########################################
source ./services_helper.sh

# Colors
NC='\033[0m'
RED='\e[01;31m'
GREEN='\e[32m'

OUTPUT=''
USER_INPUT="$*"
Flag="$2"
REFRESH_TIME=$3

# Adjusting the arguments for watch command.
if [[ "$1" == *"-l_"* ]]; then
  Flag="$1"
  REFRESH_TIME="$2"
  USER_INPUT="${*:3}"
else
  USER_INPUT="$1"
fi

# If user input is found get its status, else get the whole system and user services.
SYSTEM_SERVICES_NAMES=$(bash get_services_names.sh -su "$USER_INPUT"  | tr ' ' '\n' )
SYSTEM_SERVICES_SPACED=$(bash get_services_names.sh -su "$USER_INPUT")

# Check for -l flag
if [ "$USER_INPUT" == "-l_"  ] || [ ! -z "$REFRESH_TIME" ]; then
  echo "Assistant Services Status(refreshes every $REFRESH_TIME seconds). Press Ctrl+c to exit."
  echo ""
fi

#Check for -e services
if [ "$Flag" == "e" ]; then
    service_status=$(run_systemctl_if_services_exists list-units "$SYSTEM_SERVICES_SPACED")
    service_run_status=$(echo "$service_status" | grep failed | grep "assistant-")
    service_active_status=$(echo "$service_run_status" | awk -F ' ' '{print $2}')
    run_systemctl_if_services_exists status "$service_active_status"
    exit
fi

echo "$SYSTEM_SERVICES_NAMES" | (while read service_name; do
  # Getting the output of the services systemctl command based on the systemctl command type.
  # Extracting the service active status line
  service_active_status=$(run_systemctl_if_services_exists is-active "$service_name")

  # Coloring the output, green if sucess.
  if [ "$service_active_status" == 'active' ]
  then
    service_active_status="${GREEN}$service_active_status${NC}\n"
  else
    service_active_status="${RED}$service_active_status${NC}\n"
  fi

  #  Save the output in a variable to print the value later justified
  if [ "$OUTPUT" == "" ]
  then
    OUTPUT="${service_name}\t--->\t${service_active_status}"
  else
    OUTPUT="${OUTPUT}\n${service_name}\t--->\t${service_active_status}"
  fi
done
printf "${OUTPUT}" | column -t )


