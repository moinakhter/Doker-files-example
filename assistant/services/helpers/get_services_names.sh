#!/usr/bin/env bash

# This shell file will return the assistant services name that are placed under the
# /etc/systemd/system/ directory

OUTPUT=''
USER_INPUT="$@"
USER_INPUT_FOUND=false

OS_ASSISTANT_SERVICES=$(ls /etc/systemd/system/ | grep -F assistant)
USER_OS_ASSISTANT_SERVICES=$(ls ~/.config/systemd/user | grep -F assistant)

ASSISTANT_SERVICES="$OS_ASSISTANT_SERVICES"

# Check whether -u flag is provided among the shell args
# the -u flag means that the script should contain the user services along with the system services.
if [[ "$USER_INPUT" == *"-u"* ]]; then
  ASSISTANT_SERVICES="$USER_OS_ASSISTANT_SERVICES"
fi

# Check whether -su flag is provided among the shell args
# the -su flag means that the script should contain the user services along with the system services.
if [[ "$USER_INPUT" == *"-su"* ]]; then
  ASSISTANT_SERVICES=$(printf "$ASSISTANT_SERVICES\n$USER_OS_ASSISTANT_SERVICES")
fi

# Removing the flags if exists from the user input (inorder to prepare them for the loop).
USER_INPUT=${USER_INPUT/"-u"/""}
USER_INPUT=${USER_INPUT/"-su"/""}

ASSISTANT_SERVICES_NAMES="${ASSISTANT_SERVICES//"$SERVICES_EXTENTION"/""}"

# Check if the provided user argument is among the system services names
(for input in $USER_INPUT; do
  IS_USER_PROVIDED_SERVICE_EXIST=$(echo "$ASSISTANT_SERVICES_NAMES" | grep -w "$input")
  # User provided service does not exist
  if [ -z "$IS_USER_PROVIDED_SERVICE_EXIST" ]
  then
    USER_INPUT_FOUND=false
    break
  else
    # User provided service name tends to be one of the system services name
    USER_INPUT_FOUND=true
    # Append user input to string
    if [ "$OUTPUT" == "" ]
    then
      OUTPUT="${input}"
    else
      OUTPUT="${OUTPUT} ${input}"
    fi
  fi
done

# If the user provided argument does not exists among the services, return all of them
if [ -z "$IS_USER_PROVIDED_SERVICE_EXIST" ] && [ "$USER_INPUT_FOUND" == false ]
then
  echo "$ASSISTANT_SERVICES_NAMES" | tr '\n' ' '
else
  # If user argument exist among the system services then return it
  printf "${OUTPUT}"
fi)