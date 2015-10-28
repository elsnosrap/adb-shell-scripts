#!/bin/bash

#
# pull-db
# Inspect the database from your device
# Cedric Beust
# http://beust.com/weblog/2015/07/09/easily-inspect-your-sqlite-database-on-android/
 
# Add actual package name and uncomment 
#PKG=<<package name here>>

# Add actual DB name here
#DB=<<db filename>>
 
adb shell "run-as $PKG chmod 755 /data/data/$PKG/databases"
adb shell "run-as $PKG chmod 666 /data/data/$PKG/databases/$DB"
adb shell "rm /sdcard/$DB"
adb shell "cp /data/data/$PKG/databases/$DB /sdcard/$DB"
 
rm -vf $PWD/${DB}
adb pull /sdcard/${DB} $PWD/${DB}
