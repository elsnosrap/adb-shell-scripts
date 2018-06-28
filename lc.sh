#!/bin/bash
#  lc.sh - A simplified logcat script.

# Include the shell script that contains the function to select a device
source $HOME/dev/git/shell-scripts/adbwrapper-func.sh

# Grab the device to use
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
  echo "Please select a valid device"
  exit 0;
fi

# If user specified "-c" flag, clear the log
if [[ "$#" = 1 && "$1" = "-c" ]]; then
	# Clear the log
	adb -s $SELECTED_DEVICE logcat -c
fi

# Start logcat and tee it to a file
adb -s $SELECTED_DEVICE logcat -v threadtime | tee ./logcat.log
