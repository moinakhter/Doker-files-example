#!/usr/bin/env bash
#
##########################################
# This shell file is useful to check if the given service name exist
##########################################

os_assistant_services=$(ls /etc/systemd/system/ | grep -F assistant | tr '\n' ' ')
USER_OS_ASSISTANT_SERVICES=$(ls ~/.config/systemd/user | grep -F assistant)

#######################################
# Apply the systemctl command on the given assistant service, regardless of the service type (user, os).
# Globals:
#   $OS_ASSISTANT_SERVICES
#   $USER_OS_ASSISTANT_SERVICES
# Arguments:
#   $1 systemctl command e.g. (status, stop, start, restart, enable)
#   $2 assistant service to apply the systemctl command on
#######################################
function run_systemctl_if_services_exists() {
  REQUESTED_SERVICES="$2"
  HAS_ALL_SERVICES=$(echo "$REQUESTED_SERVICES" | grep -w "$USER_OS_ASSISTANT_SERVICES" )
  HAS_SYSTEM_SERVICES=$(echo "$REQUESTED_SERVICES" | grep -v "$USER_OS_ASSISTANT_SERVICES")
  GET_SYSTEM_SERVICES=$(echo $REQUESTED_SERVICES | sed -e "s/${USER_OS_ASSISTANT_SERVICES}//g")
  HAS_PERMISSION=$(sudo -l | grep "ALL" )

  if [ $(echo "$USER_OS_ASSISTANT_SERVICES" | grep "$2") ]; then
    systemctl --user --no-pager -l "$1" "$2"
    return
  fi
  if [ -n  "$HAS_ALL_SERVICES"  ] && [ ! -z "$HAS_PERMISSION" ]; then
    systemctl --user --no-pager -l "$1" $USER_OS_ASSISTANT_SERVICES &
    sudo systemctl --no-pager -l "$1" $GET_SYSTEM_SERVICES
  fi
  if [[ -n $HAS_SYSTEM_SERVICES ]]; then
    sudo systemctl --no-pager -l "$1" $2
  fi
}