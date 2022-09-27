#!/usr/bin/env bash

#######################################
# Stops all the assistant related OS processes.
#######################################
function stop_assistant_processes() {
  process_ids=`/bin/ps -fu $USER| grep "Dizzy" | grep -v "grep" | grep -v "clear_processes" | grep -v "restart_processes" | awk '{print $2}'`
  for pid in $process_ids
  do
    kill -9 $pid
  done
}

stop_assistant_processes
