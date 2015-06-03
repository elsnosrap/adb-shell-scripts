#!/bin/bash

# This is a wrapper for adb.  If there are multiple devices / emulators, this script will prompt for which device to use
# Then it'll pass whatever commands to that specific device or emulator.

# Run adb devices once, in event adb hasn't been started yet
BLAH=$(adb devices)

# Grab the IDs of all the connected devices / emulators
IDS=($(adb devices | sed '1,1d' | sed '$d' | cut -f 1 | sort))
NUMIDS=${#IDS[@]}

# Check for number of connected devices / emulators
if [[ 0 -eq "$NUMIDS" ]]; then
	# No IDs, exit
	echo "No emulators or devices detected - nothing to do."
	exit 0;
elif [[ 1 -eq "$NUMIDS" ]]; then
	# Just one device / emulator
	adb $@
	exit 0;
fi

# If we got here, there are multiple devices, need to get information then prompt user for which device/emulator to uninstall from

# Grab the model name for each device / emulator
declare -a MODEL_NAMES
for (( x=0; x < $NUMIDS; x++ )); do
	MODEL_NAMES[x]=$(adb devices | grep ${IDS[$x]} | cut -f 1 | xargs -I $ adb -s $ shell cat /system/build.prop | grep "ro.product.model" | cut -d "=" -f 2 | tr -d ' \r\t\n')
done

# Grab the platform version for each device / emulator
declare -a PLATFORM_VERSIONS
for (( x=0; x < $NUMIDS; x++ )); do
	PLATFORM_VERSIONS[x]=$(adb devices | grep ${IDS[$x]} | cut -f 1 | xargs -I $ adb -s $ shell cat /system/build.prop | grep "ro.build.version.release" | cut -d "=" -f 2 | tr -d ' \r\t\n')
done

echo "Multiple devices detected, please select one"
for (( x=0; x < $NUMIDS; x++ )); do
	echo -e "$[x+1]: ${IDS[x]}\t\t${PLATFORM_VERSIONS[x]}\t\t${MODEL_NAMES[x]}"
done
echo -n "> "
read USER_CHOICE

# Validate user entered a number
if [[ $USER_CHOICE =~ ^[0-9]+$ ]]; then
	echo "executing following command:"
	echo "    adb -s ${IDS[$USER_CHOICE-1]} $@"
	adb -s ${IDS[$USER_CHOICE-1]} $@
else
	echo "You must enter a number"
fi
