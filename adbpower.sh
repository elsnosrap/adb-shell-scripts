#!/bin/bash

# This script powers on, and unlocks a device.
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

# Send the command to turn the device on
adb -s $SELECTED_DEVICE shell input keyevent 26

# If '0' was passed in, just exit as that means power the device off
if [[ "$1" = "0" ]]; then
  exit 0;
fi

# User either passed in no other command, or they passed in something we don't care about.
# Send the command to 'swipe to unlock'
adb -s $SELECTED_DEVICE shell input keyevent 82

# If supplied a pin code, enter it
if [[ "$#" = 1 && "$1" != "0" ]]; then
  # Enter the supplied value as the pin
  adb -s ${SELECTED_DEVICE} shell input text $1

  # Press the 'Enter' button to unlock the device
  adb -s $SELECTED_DEVICE shell input keyevent 66
fi
