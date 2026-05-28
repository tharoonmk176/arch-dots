#!/usr/bin/env bash

pid=$(pidof waybar)

if [[ -n "$pid" ]]; then
  kill -SIGUSR1 "$pid"
  notify-send "Waybar" "Toggled visibility"
else
  waybar &
  notify-send "Waybar" "Started"
fi
