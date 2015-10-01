#!/bin/bash

# This script will remove various apps from a device

# Apps to remove
#APP_NAME[0]="com.bellmedia.canald"
#APP_NAME[1]="com.bellmedia.canalvie"
#APP_NAME[2]="com.bellmedia.ztele"
#APP_NAME[3]="com.bellmedia.vrak"
#APP_NAME[0]="org.metopera"
#APP_NAME[0]="com.bcgs.commonfilms"
#APP_NAME[0]="org.metopera.dev"
#APP_NAME[1]="org.metopera"
APP_NAME[0]="com.brightcove.multiactivitysample"
#APP_NAME[1]="org.metopera.dev.qa"
#APP_NAME[6]="com.brightcove.admob"
#APP_NAME[11]="com.birdjunior.trakalarm"
#APP_NAME[12]="net.ajplus.ajplus"
NUMAPPS=${#APP_NAME[@]}

# Include the shell script that contains the function to select a device
source $SHELL_SCRIPTS_HOME/adbwrapper-func.sh

# Get the device to use for this command
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
	echo "Please select a valid device"
	exit 0;
fi

# Iterate through all defined apps and remove them
for (( x=0; x < $NUMAPPS; x++ )); do
	echo "Uninstalling ${APP_NAME[$x]} from device id $SELECTED_DEVICE"
	adb -s $SELECTED_DEVICE uninstall ${APP_NAME[$x]}
done

