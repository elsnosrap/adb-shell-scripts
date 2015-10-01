#!/bin/bash

# This script sends text to a device.
# If there are multiple devices / emulators, this script will prompt for which device to use.

# Include the shell script that contains the function to select a device
source $SHELL_SCRIPTS_HOME/adbwrapper-func.sh

# Get the device to use for this command
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
  echo "Please select a valid device"
  exit 0;
fi

# Execute the requested command
adb -s ${SELECTED_DEVICE} shell input text $@
