#!/usr/bin/env bash

# Helper to show Eww OSD
show_osd() {
    touch /tmp/osd_was_called
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
    wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
esac

vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
muted=$(echo "$vol" | grep -c MUTED)

if [[ "$muted" -gt 0 ]]; then
    show_osd 0 "󰝟"
else
    pct=$(echo "$vol" | awk '{print int($2 * 100)}')
    if   (( pct >= 67 )); then icon="󰕾"
    elif (( pct >= 34 )); then icon="󰖀"
    else                        icon="󰕿"
    fi
    show_osd "$pct" "$icon"
fi
