#!/bin/bash

# emulator.sh - helper script to make running Android emulator easier

# Usage function
function usage() {
	echo "The following options are supported:"
	echo "-w"
	echo "	Wipes all user data on the emulator"
	echo " "
	echo "-n [OPTION]"
	echo "	Runs the emulator at either 3g or HSDPA speeds.  Specify either 3g or hsdpa for [OPTION]."
	echo " "
	echo " -s [OPTION]"
	echo "	sets the scale to use"
	echo "-h"
	echo "	Display this help"
}

# Parse command line arguments
ARGS=`getopt wn:hs: $*`
SCALE=".41";
eval set -- "$ARGS";
while true; do
	case "$1" in
		-w)
			WIPE="-wipe-data";
			shift;
		;;
		-n)
			shift;
			if [ -n "$1" ]; then
				if [ "$1" == "3g" ]; then
					NETWORK_DELAY="-netdelay umts";
					NETWORK_SPEED="-netspeed umts";
				elif [ "$1" == "hsdpa" ]; then
					NETWORK_SPEED="-netspeed hsdpa";
				fi
				shift;							
			fi
		;;
		-s)
			shift;
			if [ -n "$1" ]; then
				SCALE="$1";
				shift;
			fi
		;;
		-h)
			shift;
			usage
			exit 0
		;;
		--)
			shift;
			break;
		;;
		*)
			shift;
			continue;
	esac
done

# Run the Android emulator with the given options
emulator -avd $@ $WIPE $NETWORK_DELAY $NETWORK_SPEED -scale $SCALE -partition-size 512 -timezone America/New_York &
