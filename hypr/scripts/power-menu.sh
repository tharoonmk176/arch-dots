#!/usr/bin/env bash

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Launch wlogout with some nice margins if desired, or fullscreen
wlogout -b 5 -T 300 -B 300 -L 300 -R 300 &
