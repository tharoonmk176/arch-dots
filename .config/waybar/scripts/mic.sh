#!/usr/bin/env bash
# Microphone status (JSON)

if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q MUTED; then
    printf '{"text":"󰍭","tooltip":"Mic muted — click to unmute","class":"muted"}\n'
    exit 0
fi

vol=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{print int($2*100)}')
printf '{"text":"󰍬 %s%%","tooltip":"Mic %s%% — scroll in bar settings","class":"normal"}\n' "${vol:-0}" "${vol:-0}"
