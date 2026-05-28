#!/usr/bin/env bash
# Hyprland layout indicator (JSON)

layout=$(hyprctl getoption general:layout 2>/dev/null | awk 'NR==1 {print $2}' | tr -d '"')

case "$layout" in
    master) icon="󰒓" ;;
    dwindle) icon="󰔫" ;;
    *) icon="󰕮" ;;
esac

printf '{"text":"%s %s","tooltip":"Layout: %s — click to toggle","class":"layout"}\n' "$icon" "$layout" "$layout"
