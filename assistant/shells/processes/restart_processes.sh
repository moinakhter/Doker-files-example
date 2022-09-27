#!/usr/bin/env bash

# This bash sript will deploy the system services inside the linux base directory
# which is /etc/systemd/system/ as will as changing these services content to match the os conf

# The current file base dir (add_services.sh).
source ./clear_processes.sh

source ./system_services.sh restart
source ./system_services.sh status