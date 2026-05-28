#!/usr/bin/env bash

state_file="/tmp/hypr-gaming-mode"

if [[ -f "$state_file" ]]; then
  rm "$state_file"
  hyprctl eval "hl.config({ animations = { enabled = true } })"
  hyprctl eval "hl.config({ decoration = { blur = { enabled = true } } })"
  hyprctl eval "hl.config({ decoration = { active_opacity = 0.97, inactive_opacity = 0.80 } })"
  hyprctl eval "hl.config({ general = { allow_tearing = false } })"
  notify-send "Gaming Mode" "Disabled — animations & blur restored"
else
  touch "$state_file"
  hyprctl eval "hl.config({ animations = { enabled = false } })"
  hyprctl eval "hl.config({ decoration = { blur = { enabled = false } } })"
  hyprctl eval "hl.config({ decoration = { active_opacity = 1.0, inactive_opacity = 1.0 } })"
  hyprctl eval "hl.config({ general = { allow_tearing = true } })"
  notify-send "Gaming Mode" "Enabled — animations/blur off, full opacity, tearing allowed"
fi
pkill -RTMIN+6 waybar 2>/dev/null || true
