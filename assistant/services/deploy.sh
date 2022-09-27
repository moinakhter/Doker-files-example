#!/usr/bin/env bash

# This bash sript will deploy the system services inside the linux base directory
# which is /etc/systemd/system/ as will as changing these services content to match the os conf

# The current file base dir (add_services.sh).
FILE_DIR=$(dirname "$0")
source "$FILE_DIR"/helpers/deploy_helper.sh

# Deploying system and user services to the linux OS directories.
deploy_services -s && deploy_services -u

# Load the new services by reloading the services daemon.
sudo systemctl daemon-reload && systemctl --user daemon-reload

# Enabling all of the assistant services.
./system_services.sh enable

# Starting all of the system services.
./system_services.sh start

printf "${GREEN}Application services has been added and running!${NC}\n"