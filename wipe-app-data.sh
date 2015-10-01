#!/bin/bash

# This script will wipe all of an app's data from a given device

# Apps to wipe
#APP_NAME[0]="com.bcgs.commonfilms"
APP_NAME[0]="com.brightcove.multiactivitysample"
NUMAPPS=${#APP_NAME[@]}

# Include the shell script that contains the function to select a device
source $SHELL_SCRIPTS_HOME/adbwrapper-func.sh

# Get the device to use for this command
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
  echo "Please select a valid device"
  exit 0;
fi

# Iterate through all defined apps and wipe their data
for (( x=0; x < $NUMAPPS; x++ )); do
  echo "Wiping data for app ${APP_NAME[$x]} from device id $SELECTED_DEVICE"
  adb -s $SELECTED_DEVICE shell pm clear ${APP_NAME[$x]}
done

