#!/bin/bash

# This script takes a screen shot from the selected device.
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

# Take the screen shot and dump to a file
adb -s ${SELECTED_DEVICE} shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > ./screencap.png
