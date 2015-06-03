#!/bin/bash
CONKY_ID=$(pgrep -o conky)
echo "Killing conky, pid $CONKY_ID"
kill -9 $CONKY_ID

echo "Starting conky"
conky >~/.conky.log 2>&1
