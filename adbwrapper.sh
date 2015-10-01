#!/bin/bash

# This is a wrapper for adb.
# If there are multiple devices / emulators, this script will prompt for which device to use.
# Then it'll pass the specified commands to the selected device.

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
adb -s ${SELECTED_DEVICE} $@
