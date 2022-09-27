#!/usr/bin/env bash
#
##########################################
# Basic Info:
# This script generates the assistant related custom shell commands.
# the commands will be saved in /usr/local/bin
##########################################

# The directory of the current file
readonly GLOBALS_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# The main directory of the project
readonly PROJECT_DIR=$(echo "$GLOBALS_FILE_DIR" | awk -F/commands '{print $1}')

# The directory of where the assistant commands should be placed.
# The directory of {system or docker image}  where the assistant commands should be placed.
if [ "$1" = "-d" ] || [ "$1" = "-docker" ]
then
    COMMANDS_BASE_DIR=/usr/local/bin
else
    COMMANDS_BASE_DIR=~/.local/bin
fi


# The Assistant's commands directory.
readonly COMMANDS_PROJ_DIR="$PROJECT_DIR/commands"

# The placeholder of the project dir in the commands files.
readonly PROJECT_DIR_PLACEHOLDER="(proj_dir)"

# Commands available in the command directory, except for the deploy.sh and the readme files.
readonly COMMANDS=$(ls "$COMMANDS_PROJ_DIR" | awk '! (/deploy.sh/ || /README.md/)')

# creates if does not exists directory where the assistant commands should be placed.
mkdir -p "$COMMANDS_BASE_DIR"
sudo chmod u+x "$COMMANDS_BASE_DIR"

echo "$COMMANDS" | while read command_name; do
  command_file_content=$(cat $COMMANDS_PROJ_DIR/$command_name)

  # Replaces (proj_dir) placeholder string that is existed inside the command file, with the project dir
  final_command_content="${command_file_content/"$PROJECT_DIR_PLACEHOLDER"/"$PROJECT_DIR"}"

  # Write the final command value to the OS command base directory.
  sudo sh -c "echo -n '$final_command_content' > '$COMMANDS_BASE_DIR/$command_name'"

  # Giving the command executing access to the system user
  sudo chmod -R 755 "$COMMANDS_BASE_DIR/$command_name"
done


