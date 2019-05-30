#!/bin/bash
# logcat.sh - Script to display logcat

# Include the shell script that contains the function to select a device
source $SHELL_SCRIPTS_HOME/adbwrapper-func.sh

# The regular expression to be used when filtering out lines
FILTER_SUPPRESS_REGEX="onMeasure|setMeasuredDimension|WifiService|PowerManagerService|DeviceScanner|WifiStateMachine|GnssLocationProvider"

# Usage function
function usage() {
    echo "The following options are supported:"
    echo "-f            Filters out all lines that match the regular expression '$FILTER_SUPPRESS_REGEX'"
    echo "-h            Display this help"
    echo "-c            Clear logcat via adb logcat -c command before displaying logcat"
}

# Check which options the user has specified
ARGS=`getopt fhc $*`
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
        -f)
            USE_REGEX_FILTER="1"
            shift;;
        -c)
            NOW=$(date +"%m-%d %H:%M:%S.000")
            shift;;
        -h)
            usage
            exit 0;
    esac
done

# Run adb devices once, in case adb hasn't been started yet
BLAH=$(adb devices)

# Get the device to use for this command
selectDevice SELECTED_DEVICE

# Make sure the user selected a device
if [[ "$SELECTED_DEVICE" = "0" ]]; then
    echo "Please select a valid device"
    exit 0;
fi

# Check if we were asked to filter by the hard-coded regular expression
if [[ -z $USE_REGEX_FILTER ]]; then
    # Not filtering by regex, check if we need to clear the logcat output
    if [[ -n $NOW ]]; then
        adb -s $SELECTED_DEVICE logcat -v threadtime -T "$NOW"
    else
        adb -s $SELECTED_DEVICE logcat -v threadtime
    fi
else
    # We'll be filtering by the hard-coded regular expression
    # Check if we need to 'clear' logcat output
    if [[ -n $NOW ]]; then
        adb -s $SELECTED_DEVICE logcat -v threadtime -T "$NOW" | egrep -v "$FILTER_SUPPRESS_REGEX" --line-buffered
    else
        adb -s $SELECTED_DEVICE logcat -v threadtime | egrep -v "$FILTER_SUPPRESS_REGEX" --line-buffered
    fi
fi

