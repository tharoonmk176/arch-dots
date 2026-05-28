#!/usr/bin/env bash

current=$(hyprctl getoption general:layout | head -1 | awk '{print $2}')

if [[ "$current" == "dwindle" ]]; then
  hyprctl eval "hl.config({ general = { layout = 'master' } })"
  notify-send "Layout" "Switched to Master"
else
  hyprctl eval "hl.config({ general = { layout = 'dwindle' } })"
  notify-send "Layout" "Switched to Dwindle"
fi
pkill -RTMIN+7 waybar 2>/dev/null || true
