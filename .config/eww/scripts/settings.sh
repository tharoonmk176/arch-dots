#!/usr/bin/env bash
if command -v nwg-look >/dev/null; then
    nwg-look
elif command -v lxappearance >/dev/null; then
    lxappearance
else
    notify-send "Settings" "No settings manager found (nwg-look or lxappearance)"
fi
