#!/usr/bin/env bash
# Script to input username/password in an app
# Requires cloning https://github.com/mitsnosrap/adb-shell-scripts and following setup instructions in README

# User name & Password
USER="YOUR USERNAME HERE"
PASSWORD="YOUR PASSWORD HERE"

# Include the shell script that contains the function to select a device
source $SHELL_SCRIPTS_HOME/adbwrapper-func.sh

# Get the device to use for this command
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
    echo "Please select a valid device"
    exit 0;
fi

# Enter the user name first
adb -s $SELECTED_DEVICE shell input text $USER

# Tab to the next field
adb -s $SELECTED_DEVICE shell input keyevent 61

# Enter the password
adb -s $SELECTED_DEVICE shell input text $PASSWORD

# Tab to "Forgot password?"
adb -s $SELECTED_DEVICE shell input keyevent 61

# Tab to the arrow
adb -s $SELECTED_DEVICE shell input keyevent 61

# Press the enter key to submit the form
adb -s $SELECTED_DEVICE shell input keyevent 66
