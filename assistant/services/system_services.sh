#!/usr/bin/env bash
#
##########################################
# This shell file can start, stop or restart all of the OS services related to the assistant based on the passed argument
# use samples:
# ./system_services.sh start
# ./system_services.sh restart
# ./system_services.sh status
# ./system_services.sh enable
# ./system_services.sh stop
##########################################

# The deployment script of the assistant shell commands.
FILE_DIR=$(dirname "$0")
source "$FILE_DIR"/helpers/globals.sh
source "$FILE_DIR"/helpers/services_helper.sh

ARGS="$@"
USER_ARG_FLAG=""
USER_INPUT=""
SYSTEM_SERVICES_EXISTS="$(ls "$OS_SERVICES_DIR" | grep "assistant")"

# check if services are deployed
if  [ -z "$SYSTEM_SERVICES_EXISTS" ] ; then
  printf "${RED}Services are not deployed!!\n${YELLOW}Please deploy the services by running the following command\n${NC}[assistant -s deploy]\n"
  exit 0
fi

# check if input has flags ex(-d,-l)
if [[ "$1" == *"-"* ]]; then
  USER_ARG_FLAG="$1"
  USER_INPUT="$2"
else
  USER_INPUT="$1"
fi

# All of the terminal args without the first command witch will be one of the ACCEPTED_ARGS
USER_REQUESTED_SERVICE=${ARGS/"$USER_ARG_FLAG"/""}
USER_REQUESTED_SERVICE=${USER_REQUESTED_SERVICE/"$USER_INPUT"/""}

ACCEPTED_ARGS=("status" "disable" "cat" "restart" "start" "stop" "enable")

# One of the accepted args has been requested.
SYSTEM_SERVICES_NAMES=$(cd helpers/ ; bash ./get_services_names.sh -su "$USER_REQUESTED_SERVICE" | tr '\n' ' ')

#get help txt file for commands
if [ "$USER_ARG_FLAG" == "-h" ] || [ "$USER_ARG_FLAG" == "--help" ]; then
  if [ -z "$USER_INPUT" ]; then
  ( cd helpers/ ; cat help.txt )
  exit 0
  fi
fi

# Check if the user argument is absent
if [ -z "$USER_INPUT" ]; then
  ( cd helpers/ ; cat help.txt )
  printf "${YELLOW}An argument must be passed to the script!${NC}\n"
  exit 0
fi

# Check if the user argument is among the accepted argument list.
if printf '%s\n' "${ACCEPTED_ARGS[@]}" | grep -q "^$USER_INPUT$"; then
  if [ "$USER_ARG_FLAG" == "-l" ] && [ "$USER_INPUT" == "status" ]; then
    # Services status with loop flag has been requested
    # Set the refresh interval time for the watch command
    REFRESH_TIME=2
    (cd helpers/ && watch -ct --interval $REFRESH_TIME ./services_status.sh "-l_" "$REFRESH_TIME" "$USER_REQUESTED_SERVICE")
  elif [ "$USER_ARG_FLAG" == "-d" ] && [ "$USER_INPUT" == "status" ]; then
    # services status with details flag has been requested.
    run_systemctl_if_services_exists "$USER_INPUT" "$SYSTEM_SERVICES_NAMES"
  elif [ -z "$USER_ARG_FLAG" ] && [ "$USER_INPUT" == "status" ]; then
    # services status has been requested.
    (cd helpers/ ; bash ./services_status.sh "$USER_REQUESTED_SERVICE")
  elif [ "$USER_ARG_FLAG" == "-e" ] && [ "$USER_INPUT" == "status" ]; then
    #check failed servcies
    (cd helpers/ && bash ./services_status.sh "$USER_REQUESTED_SERVICE" "e")
  elif [ -z "$USER_ARG_FLAG" ]; then
    run_systemctl_if_services_exists "$USER_INPUT" "$SYSTEM_SERVICES_NAMES"
  else
     printf "${YELLOW}You can not use this flag ($USER_ARG_FLAG) with ($USER_INPUT) command!${NC}\n"
     exit 0
  fi
else
  printf "${YELLOW}You can not use your input ($USER_INPUT) as an argument to the script!${NC}\n"
  printf "${YELLOW}Only usage of start, status, stop, restart, enable commands is permitted.${NC}\n"
  exit 0
fi
