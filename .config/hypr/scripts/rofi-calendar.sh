#!/usr/bin/env bash
# Rofi calendar popup — launched from waybar clock

set -euo pipefail

ROFI_THEME="${HOME}/.config/rofi/base.rasi"

# Get current month/year
month=$(date +%-m)
year=$(date +%Y)

show_month() {
    local m=$1 y=$2
    local name
    name=$(date -d "$y-$m-01" +'%B %Y' 2>/dev/null || echo "Month $m $y")
    local cal
    cal=$(cal -m "$m" "$y" 2>/dev/null || cal "$m" "$y" 2>/dev/null)
    printf '%s\n\n%s' "$name" "$cal"
}

content=$(show_month "$month" "$year")

echo "$content" | rofi -dmenu -i -p "Calendar" -theme "$ROFI_THEME" -no-custom -format i >/dev/null 2>&1 || true
