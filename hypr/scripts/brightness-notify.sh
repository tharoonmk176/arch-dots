#!/usr/bin/env bash

# Helper to show Eww OSD
show_osd() {
    local value=$1
    local icon=$2
    
    # Ensure eww daemon is running
    if ! pgrep -x "eww" > /dev/null; then
        eww daemon
        sleep 0.5
    fi
    
    eww update volume="$value" osd_icon="$icon"
    eww open osd 2>/dev/null || true
    
    # Reset timer
    pkill -f "sleep 4 && eww close osd"
    (sleep 4 && eww close osd) &
}

action="$1"

case "$action" in
  up)
    brightnessctl -e4 -n2 set 2%+
    ;;
  down)
    brightnessctl -e4 -n2 set 2%-
    ;;
esac

raw=$(brightnessctl get)
max=$(brightnessctl max)
pct=$(( raw * 100 / max ))

if   (( pct >= 67 )); then icon="󰃠"
elif (( pct >= 34 )); then icon="󰃟"
else                        icon="󰃞"
fi

show_osd "$pct" "$icon"
