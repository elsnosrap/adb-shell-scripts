#!/bin/bash
# logcat.sh - Script to display logcat for a single app

# Enter the app's package name in the following variable
APP_ID="com.brightcove.lightbox"
APP_ID2="com.brightcove.testvideo"

# The regular expression to be used when filtering out lines
FILTER_SUPPRESS_REGEX="onMeasure|setMeasuredDimension|WifiService|PowerManagerService|DeviceScanner|WifiStateMachine"

# Usage function
function usage() {
	echo "The following options are supported:"
	echo "-a [APP-ID]   Specifies a different APP_ID to use in place of $APP_ID"
	echo "-f            Filters out all lines that match the regular expression '$FILTER_SUPPRESS_REGEX'"
	echo "-t            Uses the alternative APP_ID of $APP_ID2"
	echo "-h            Display this help"
	echo "-u            Do not filter logcat output by process ID for $APP_ID.  Should not be used in conjunction with -t or -a options."
	echo "-c            Clear logcat via adb logcat -c command before displaying logcat"
}

# Check which optiosn the user has specified
ARGS=`getopt fhtuca: $*`
if [ $? != 0 ]
then
	usage
	exit 0;
fi

set -- $ARGS
for i
do
	case "$i"
	in
		-t)
			APP_ID=$APP_ID2;
			shift;;
		-f)
			USE_REGEX_FILTER="1"
			shift;;
		-a)
			APP_ID=$2;
			shift;;
		-u)
			APP_ID="";
			shift;;
		-c)
			NOW=$(date +"%m-%d %H:%M:%S.000")
			shift;;
		-h)
			usage
			exit 0;
	esac
done

# Logcat on Android 5.0+ may not always clear when passed the -c flag:
# https://code.google.com/p/android/issues/detail?id=78916
# Therefore, implement the workaround where logcat is started with a flag to only show most recent content

# Check if user wants to clear logcat
#if [[ -n $CLEAR_LOGCAT ]]; then
#	adb logcat -c
#	echo "Logcat cleared"
#fi

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
    # Only one device
	# See if we need to filter on APP_ID
	if [[ -z $APP_ID ]]; then
		# Not filtering on APP_ID, check if we need to filter out based on the regex variable
		if [[ -z $USE_REGEX_FILTER ]]; then
			# Check if we need to 'clear' logcat output
			if [[ -n $NOW ]]; then 
				adb logcat -v threadtime -T "$NOW"
			else
				adb logcat -v threadtime
			fi
		else
			# Check if we need to 'clear' logcat output
			if [[ -n $NOW ]]; then
				adb logcat -v threadtime -T "$NOW" | egrep -v "$FILTER_SUPPRESS_REGEX" --line-buffered
			else
				adb logcat -v threadtime | egrep -v "$FILTER_SUPPRESS_REGEX" --line-buffered
			fi
		fi
	else
		# Verify app is running
		PID=`adb shell ps | grep "$APP_ID"`
		if [[ -z $PID ]]; then
			echo "The app $APP_ID is not running on the specified device"
			exit 0;
		fi
		# Just one device / emulator, run logcat
		if [[ -z $USE_REGEX_FILTER ]]; then
			# Check if we need to clear logcat output
			if [[ -n $NOW ]]; then
				adb logcat -v threadtime -T "$NOW" | grep `adb shell ps | grep "$APP_ID" | cut -c10-15` --line-buffered
			else
				adb logcat -v threadtime | grep `adb shell ps | grep "$APP_ID" | cut -c10-15` --line-buffered
			fi			
		else
			adb logcat -v threadtime | grep `adb shell ps | grep "$APP_ID" | cut -c10-15` --line-buffered | egrep -v "$FILTER_SUPPRESS_REGEX" --line-buffered
		fi
	fi
else

	# If we ended up here, there are multiple devices.  Need to get information then prompt user for which device/emulator to run logcat against
	# Grab the model name for each device / emulator
	declare -a MODEL_NAMES
	for (( x=0; x < $NUMIDS; x++ )); do
		MODEL_NAMES[x]=$(adb -s ${IDS[$x]} shell cat /system/build.prop 2> /dev/null | grep "ro.product.model" | cut -d "=" -f 2 | tr -d ' \r\t\n')
	done
	
	# Grab the platform version for each device / emulator
	declare -a PLATFORM_VERSIONS
	for (( x=0; x < $NUMIDS; x++ )); do
		PLATFORM_VERSIONS[x]=$(adb -s ${IDS[$x]} shell cat /system/build.prop 2> /dev/null | grep "ro.build.version.release" | cut -d "=" -f 2 | tr -d ' \r\t\n')
	done
	
	echo "Multiple devices detected, please select one"
	for (( x=0; x < $NUMIDS; x++ )); do
		echo -e "$[x+1]: ${IDS[x]}\t\t${PLATFORM_VERSIONS[x]}\t\t${MODEL_NAMES[x]}"
	done
	echo -n "> "
	read USER_CHOICE
	
	# Validate user entered a number
	if [[ $USER_CHOICE =~ ^[0-9]+$ ]]; then
		# Verify app is running
		PID=`adb -s ${IDS[$USER_CHOICE-1]} shell ps | grep "$APP_ID"`
		if [[ -z $PID ]]; then
			echo "The app $APP_ID is not running on the specified device"
			exit 0;
		fi
		if [[ -z $USE_REGEX_FILTER ]]; then
			adb -s ${IDS[$USER_CHOICE-1]} logcat -v threadtime | grep `adb -s ${IDS[$USER_CHOICE-1]} shell ps | grep "$APP_ID" | cut -c10-15` --line-buffered
		else
			adb -s ${IDS[$USER_CHOICE-1]} logcat -v threadtime | grep `adb -s ${IDS[$USER_CHOICE-1]} shell ps | grep "$APP_ID" | cut -c10-15` --line-buffered | egrep -v "$FILTER_SUPPRESS_REGEX" --line-buffered

		fi
	else
		echo "You must select a device"
	fi
fi
