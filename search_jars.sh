#!/bin/bash

# Searches any jar files in the current directory or any subdirectories for a given
# string.

# Confirm we have one argument
if [ "$#" -ne 1 ]; then
	echo "This script takes one argument to search with."
	echo "   usage: search_jars.sh my-search-term"
	exit 1;
fi

# Find all jars and iterate through them
find . -iname '*.jar' -print | while read jar; do

	# Print out the jar's name
	echo "$jar:"

	# Unzip it and read each class name
	unzip -qq -l $jar | sed 's/.* //' | while read cls; do

		# Unzip the class and grep for the search term
		unzip -c $jar $cls | grep -q '$1' && echo "   "$cls
	done
done