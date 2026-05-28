#!/usr/bin/env bash
# Minimal control-center button for Waybar

updates=0
if command -v checkupdates >/dev/null 2>&1; then
    updates=$(checkupdates 2>/dev/null | wc -l)
elif command -v paru >/dev/null 2>&1; then
    updates=$(paru -Qu 2>/dev/null | wc -l)
fi
updates=${updates// /}

if [ "${updates:-0}" -gt 0 ]; then
    printf '{"text":"󰐓","tooltip":"Settings  ·  %s updates","class":"badge"}\n' "$updates"
else
    printf '{"text":"󰐓","tooltip":"Settings & notifications","class":""}\n'
fi
