#!/bin/bash
#  get_pid.sh - Gets the PID of a given app

APP_NAME="com.example.app_name"

# Include the shell script that contains the function to select a device
source $HOME/dev/git/shell-scripts/adbwrapper-func.sh

# Grab the device to use
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
  echo "Please select a valid device"
  exit 0;
fi

# Get the PID
PID=`adb -s $SELECTED_DEVICE shell ps | grep "$APP_NAME" | cut -c10-15`

# Display it
echo "PID for \"$APP_NAME\" is \"$PID\""
