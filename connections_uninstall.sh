#!/bin/bash

# Variables used throughout script
APP_NAME="com.ibm.lotus.connections.mobile"
APP_TEST_NAME="com.ibm.lotus.connections.mobile.test"
APP_DESCRIPTION="Connections Mobile"

# Run adb devices once, in event adb hasn't been started yet
BLAH=$(adb devices)

# Grab the IDs of all the connected devices / emulators
IDS=($(adb devices | sed '1,1d' | sed '$d' | cut -f 1 | sort))
NUMIDS=${#IDS[@]}

# Check for number of connected devices / emulators
if [[ 0 -eq "$NUMIDS" ]]; then
	# No IDs, exit
	echo "One or more devices / emulators must be connected."
	exit 0;
elif [[ 1 -eq "$NUMIDS" ]]; then
	# Just one device / emulator, run standard uninstall
	echo "Uninstalling from device id ${IDS[0]}"
	adb uninstall $APP_NAME
	adb uninstall $APP_TEST_NAME
	exit 0;
fi

# If we got here, there are multiple devices, need to get information then prompt user for which device/emulator to uninstall from

# Grab the model name for each device / emulator
declare -a MODEL_NAMES
for (( x=0; x < $NUMIDS; x++ )); do
	MODEL_NAMES[x]=$(adb -s ${IDS[$x]} shell cat /system/build.prop | grep "ro.product.model" | cut -d "=" -f 2 | tr -d ' \r\t\n')
done

# Grab the platform version for each device / emulator
declare -a PLATFORM_VERSIONS
for (( x=0; x < $NUMIDS; x++ )); do
	PLATFORM_VERSIONS[x]=$(adb -s ${IDS[$x]} shell cat /system/build.prop | grep "ro.build.version.release" | cut -d "=" -f 2 | tr -d ' \r\t\n')
done

echo "Multiple devices detected, please select one, or 'a' for all"
for (( x=0; x < $NUMIDS; x++ )); do
	echo -e "$[x+1]: ${IDS[x]}\t\t${PLATFORM_VERSIONS[x]}\t\t${MODEL_NAMES[x]}"
done
echo -n "> "
read USER_CHOICE

# Check if user wants to uninstall from all
if [[ $USER_CHOICE == "a" || $USER_CHOICE == "A" ]]; then
	for (( i=0; i < $NUMIDS; i++)); do
		echo "Removing apps from device ${IDS[$i]}"
		adb -s ${IDS[$i]} uninstall $APP_NAME
		adb -s ${IDS[$i]} uninstall $APP_TEST_NAME
	done
else
	# Validate user entered a number
	if [[ $USER_CHOICE =~ ^[0-9]+$ ]]; then
		echo "Removing apps from device ${IDS[$USER_CHOICE-1]}"
		adb -s ${IDS[$USER_CHOICE-1]} uninstall $APP_NAME
		adb -s ${IDS[$USER_CHOICE-1]} uninstall $APP_TEST_NAME
	else
		echo "You must enter a number, or enter 'a'"
	fi
fi




