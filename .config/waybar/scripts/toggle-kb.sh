#!/usr/bin/env bash
kb=$(hyprctl devices -j 2>/dev/null | jq -r '.keyboards[0].name // empty' 2>/dev/null)
if [ -n "$kb" ]; then
    hyprctl switchxkblayout "$kb" next
else
    hyprctl switchxkblayout all next 2>/dev/null || true
fi
pkill -RTMIN+8 waybar 2>/dev/null || true
