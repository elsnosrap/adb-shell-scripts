#!/bin/bash
#  lc.sh - A simplified logcat script.

source $HOME/dev/git/shell-scripts/adbwrapper-func.sh

# Grab the device to use
selectDevice SELECTED_DEVICE

# Clear the log
adb -s $SELECTED_DEVICE logcat -c

# Start logcat and tee it to a file
adb -s $SELECTED_DEVICE logcat -v threadtime | tee ./logcat.log
