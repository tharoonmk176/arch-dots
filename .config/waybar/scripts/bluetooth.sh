#!/usr/bin/env bash
# Bluetooth status for Waybar (JSON)

set -euo pipefail

if ! command -v bluetoothctl >/dev/null 2>&1; then
    printf '{"text":"","class":"hidden"}\n'
    exit 0
fi

if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    printf '{"text":"󰂲","tooltip":"Bluetooth off — click to open manager","class":"disabled"}\n'
    exit 0
fi

connected=$(bluetoothctl devices Connected 2>/dev/null | head -1)
if [ -n "$connected" ]; then
    name=$(echo "$connected" | cut -d' ' -f3- | head -c 14)
    printf '{"text":"󰂱 %s","tooltip":"%s — connected","class":"connected"}\n' "$name" "$name"
else
    printf '{"text":"󰂯","tooltip":"Bluetooth on — no device connected","class":"enabled"}\n'
fi
