#!/bin/bash

hidden=1
timer_pid=0
hide_delay=3

_cleanup() {
    kill "$timer_pid" 2>/dev/null
    exit 0
}

_show() {
    [[ $hidden -eq 0 ]] && return
    pkill -USR1 waybar 2>/dev/null
    hidden=0
}

_hide() {
    [[ $hidden -eq 1 ]] && return
    pkill -USR1 waybar 2>/dev/null
    hidden=1
}

_start_timer() {
    kill "$timer_pid" 2>/dev/null
    (
        sleep "$hide_delay"
        _hide
    ) &
    timer_pid=$!
}

_cancel_timer() {
    kill "$timer_pid" 2>/dev/null
    timer_pid=0
}

trap _cleanup TERM INT

# Ensure hidden on start
_hide

while true; do
    read -r x y <<< "$(hyprctl cursorpos 2>/dev/null | tr ',' ' ')"
    if [[ $y -lt 34 ]]; then
        _show
        _cancel_timer
    else
        if [[ $hidden -eq 0 && $timer_pid -eq 0 ]]; then
            _start_timer
        fi
    fi
    sleep 0.3
done
