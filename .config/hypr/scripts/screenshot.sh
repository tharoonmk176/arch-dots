#!/usr/bin/env bash

set -euo pipefail

mode=${1:-full}
dir="$HOME/Pictures/Screenshots"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

mkdir -p "$dir"

case "$mode" in
    full)
        grim "$file"
        ;;
    area)
        geometry=$(slurp)
        [ -n "$geometry" ] || exit 0
        grim -g "$geometry" "$file"
        ;;
    active)
        hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$file"
        ;;
    *)
        printf 'usage: %s [full|area|active]\n' "$0" >&2
        exit 2
        ;;
esac

wl-copy <"$file"
notify-send "Screenshot saved" "$(basename "$file")" 2>/dev/null || true

if [[ "${2:-}" == "--edit" ]]; then
    if command -v swappy &>/dev/null; then
        swappy -f "$file"
    elif command -v gimp &>/dev/null; then
        gimp "$file" &
    fi
fi
