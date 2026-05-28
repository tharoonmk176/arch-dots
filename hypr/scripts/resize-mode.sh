#!/usr/bin/env bash

toggle_file="/tmp/hypr-resize-mode"

if [[ -f "$toggle_file" ]]; then
  rm "$toggle_file"
  hyprctl eval "hl.dispatch(hl.dsp.submap(''))"
  notify-send "Resize Mode" "Disabled"
else
  touch "$toggle_file"
  hyprctl eval "hl.dispatch(hl.dsp.submap('resize'))"

  notify-send "Resize Mode" "Enabled — Arrow keys to resize, SUPER+SHIFT+R to exit"
fi
