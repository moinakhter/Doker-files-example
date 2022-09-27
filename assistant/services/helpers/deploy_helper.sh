#!/usr/bin/env bash

# Global services shell script constants.
source "$FILE_DIR"/helpers/globals.sh

# Place holders the values
readonly CODE_DIR_PLACEHOLDER="(code_dir)"
readonly USER_CODE_DIR_PLACEHOLDER="(usr)"
readonly PROJECT_DIR_PLACEHOLDER="(proj_dir)"

readonly SYSTEM_USERS=$(users)
readonly SYSTEM_USER=$(echo $SYSTEM_USERS | awk '{print $1;}')

# Create services sub-directories if not found.
mkdir -p "$PROJ_SERVICES_DIR"
mkdir -p "$PROJ_USER_SERVICES_DIR"

# Creating user services base directory if not found.
mkdir -p "$OS_USER_SERVICES_DIR"

# Authorizing accessing the services directory.
sudo chmod o+u+x "$OS_SERVICES_DIR"

# -s index is an alias used to represent the info required when dealing with the system OS services.
# -u index is an alias used to represent the info required when dealing with the user OS services,
declare -A SERVICE_TYPE=( ["-s", "name"]="$SERVICES_NAMES"
                          ["-s", "dir"]="$OS_SERVICES_DIR"
                          ["-s", "local-dir"]="$PROJ_SERVICES_DIR"
                          ["-u", "name"]="$USER_SERVICES_NAMES"
                          ["-u", "dir"]="$OS_USER_SERVICES_DIR"
                          ["-u", "local-dir"]="$PROJ_USER_SERVICES_DIR" )

#######################################
# Deploy the assistant services
# Globals:
#   $USER_CODE_DIR_PLACEHOLDER
#   $SYSTEM_USER
#   $PROJECT_DIR_PLACEHOLDER
#   $MAIN_PROJECT_DIR
#   $CODE_DIR_PLACEHOLDER
#   $PROJECT_CODES_DIR
#   $SERVICE_TYPE
# Arguments:
#   -u user system services.
#   -s system services.
#######################################
function deploy_services() {
  # Loop throw the services file names
  echo "${SERVICE_TYPE["$1", "name"]}" | while read service_file_name; do
    service_file_content=$(cat "${SERVICE_TYPE["$1", "local-dir"]}"/$service_file_name)

    # Replace (usr) string that is existed inside the file with the project dir
    # Change the service owner user name to the system user
    set_service_user_to_current="${service_file_content/"$USER_CODE_DIR_PLACEHOLDER"/"$SYSTEM_USER"}"

    # Replace (dir) string that is existed inside the file with the project dir
    # and move the service file to the os services directory
    set_service_base_dir="${set_service_user_to_current/"$PROJECT_DIR_PLACEHOLDER"/"$MAIN_PROJECT_DIR"}"

    set_codes_base_dir="${set_service_base_dir/"$CODE_DIR_PLACEHOLDER"/"$PROJECT_CODES_DIR"}"

    # Write the final service value to the OS services directory
    echo "$set_codes_base_dir" > "${SERVICE_TYPE["$1", "dir"]}/$service_file_name"
  done
}