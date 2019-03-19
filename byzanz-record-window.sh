#!/bin/bash
#
# Wrapper script for the screen recording software byzanz
# It let you select the window to be captured and writes the 
# resulting animated GIF to /tmp/recorded.gif
# 
# Copyright 2019 Luc De Louw <luc@delouw.ch>
# License: GPLv3

# Delay before starting
DELAY=10

# Duration and output file
if [ $# -gt 0 ]; then
    D="--duration=$@"
else
    echo Default recording duration 10s to /tmp/recorded.gif
    D="--duration=10 /tmp/recorded.gif"
fi

echo "Point your mouse to the window to be recored and left click to start"

XWININFO=$(xwininfo)
read X <<< $(awk -F: '/Absolute upper-left X/{print $2}' <<< "$XWININFO")
read Y <<< $(awk -F: '/Absolute upper-left Y/{print $2}' <<< "$XWININFO")
read W <<< $(awk -F: '/Width/{print $2}' <<< "$XWININFO")
read H <<< $(awk -F: '/Height/{print $2}' <<< "$XWININFO")

echo Delaying $DELAY seconds. After that, byzanz will start
for (( i=$DELAY; i>0; --i )) ; do
    echo $i
    sleep 1
done

espeak start
byzanz-record --verbose --delay=0 --x=$X --y=$Y --width=$W --height=$H $D
espeak stop
