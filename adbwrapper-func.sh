#!/bin/bash

#
# This function checks for one or more devices connected via ADB.
# It will return the device's serial number.
# If no devices are connected, it will return '0'.
# If more than one device is connected, it will prompt the user to select one.
# In that case, it will return the selected device, or '0' if they didn't select any device.
#
# USAGE:
# Call the function as follows:
#
# selectedDevice MYVAL
#
# The device's serial number will be stored in the MYVAL variable.
#
function selectDevice() {
  # Run adb devices once, in event adb hasn't been started yet
  BLAH=$(adb devices)

  # Grab the IDs of all the connected devices / emulators
  IDS=($(adb devices | sed '1,1d' | sed '$d' | cut -f 1 | sort))
  NUMIDS=${#IDS[@]}

  # Check for number of connected devices / emulators
  if [[ 0 -eq "$NUMIDS" ]]; then
    # No IDs, return 0
    eval "$1='0'"
  elif [[ 1 -eq "$NUMIDS" ]]; then
    # Only one device, return its ID
    eval "$1='${IDS[0]}'"
  else
    # There are multiple devices, need to get information then prompt user for which device/emulator to uninstall from
    # Grab the model name for each device / emulator
    declare -a MODEL_NAMES
    for (( x=0; x < $NUMIDS; x++ )); do
      MODEL_NAMES[x]=$(adb devices | grep ${IDS[$x]} | cut -f 1 | xargs -I $ adb -s $ shell cat /system/build.prop 2> /dev/null | grep "ro.product.model" | cut -d "=" -f 2 | tr -d ' \r\t\n')
    done

    # Grab the platform version for each device / emulator
    declare -a PLATFORM_VERSIONS
    for (( x=0; x < $NUMIDS; x++ )); do
      PLATFORM_VERSIONS[x]=$(adb devices | grep ${IDS[$x]} | cut -f 1 | xargs -I $ adb -s $ shell cat /system/build.prop 2> /dev/null | grep "ro.build.version.release" | cut -d "=" -f 2 | tr -d ' \r\t\n')
    done

    # Prompting user to select a device
    echo "Multiple devices detected, please select one"
    for (( x=0; x < $NUMIDS; x++ )); do
      echo -e "$[x+1]: ${IDS[x]}\t\t${PLATFORM_VERSIONS[x]}\t\t${MODEL_NAMES[x]}"
    done
    echo -n "> "
    read USER_CHOICE

    # Validate user entered a number and return appropriate serial number
    if [[ $USER_CHOICE =~ ^[0-9]+$ ]]; then
      if [[ $USER_CHOICE -gt $NUMIDS ]]; then
        eval "$1='0'"
      else  
        eval "$1='${IDS[$USER_CHOICE-1]}'"
      fi
    else
      eval "$1='0'"
    fi
  fi
}
