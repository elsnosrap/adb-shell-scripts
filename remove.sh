#!/bin/bash

# This script will remove various apps from a device

# Apps to remove
#APP_NAME[0]="com.bcgs.commonfilms"
#APP_NAME[1]="com.brightcove.multiactivitysample"
#APP_NAME[0]="jp.happyon.android.static"
#APP_NAME[1]="jp.happyon.android.dynamic"
#APP_NAME[2]="jp.happyon.android.production"
#APP_NAME[3]="jp.happyon.android"
#APP_NAME[2]="com.brightcove.nh4sample"
#APP_NAME[0]="com.brightcove.lightbox"
#APP_NAME[1]="com.brightcove.lightbox.qa"
#APP_NAME[2]="com.brightcove.lightbox.test"
#APP_NAME[0]="com.marathonventures.nosey"
#APP_NAME[3]="com.marathonventures.nosey.qa"
#APP_NAME[3]="org.metopera.dev"
#APP_NAME[4]="com.google.android.exoplayer.demo"
#APP_NAME[0]="com.settv.testplayer"

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
	adb -s $SELECTED_DEVICE uninstall ${APP_NAME[$x]} 2>/dev/null
done

