#!/usr/bin/env bash
# Pacman pending updates for Waybar (JSON)

set -euo pipefail

if command -v checkupdates >/dev/null 2>&1; then
    count=$(checkupdates 2>/dev/null | wc -l)
elif command -v paru >/dev/null 2>&1; then
    count=$(paru -Qu 2>/dev/null | wc -l)
else
    count=0
fi

count=${count// /}

if [ "${count:-0}" -eq 0 ]; then
    printf '{"text":"","tooltip":"System up to date","class":"hidden"}\n'
else
    printf '{"text":"󰚰 %s","tooltip":"%s package(s) available — click to review","class":"updates"}\n' "$count" "$count"
fi
