#!/usr/bin/env bash
# Unified theme hub — bound to Super+T

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROFI_THEME="${HOME}/.config/rofi/theme-menu.rasi"
ROFI_CONFIG="${HOME}/.config/rofi/config.rasi"

menu() {
    printf '%s\n' \
        "󰸌  Wallpaper + matugen palette" \
        "󰓑  Cycle palette (current wallpaper)" \
        "󰏘  Pick palette mode" \
        "󱓞  Color presets (54 themes)" \
        "󰑐  Re-apply current wallpaper theme"
}

rofi_pick() {
    if [ -f "$ROFI_THEME" ] && rofi -dump-theme -theme "$ROFI_THEME" >/dev/null 2>&1; then
        menu | rofi -dmenu -i -p "Theme" -theme "$ROFI_THEME" -format s
        return
    fi

    notify-send "Theme menu" "Using default rofi theme (theme-menu.rasi failed to load)" 2>/dev/null || true
    menu | rofi -dmenu -i -p "Theme" -config "$ROFI_CONFIG" -show dmenu -format s
}

run_choice() {
    case "$1" in
        *Wallpaper*)
            exec "$SCRIPT_DIR/theme-switcher.sh"
            ;;
        *Cycle*)
            exec "$SCRIPT_DIR/theme-switcher.sh" --cycle-mode
            ;;
        *Pick*)
            exec "$SCRIPT_DIR/theme-switcher.sh" --pick-mode
            ;;
        *presets*|*Presets*)
            exec "$SCRIPT_DIR/theme-preset-switcher.sh"
            ;;
        *Re-apply*|*reapply*)
            exec "$SCRIPT_DIR/theme-switcher.sh" --apply-current
            ;;
        *)
            exit 0
            ;;
    esac
}

main() {
    if ! command -v rofi >/dev/null 2>&1; then
        notify-send -u critical "Theme menu" "rofi not found — opening wallpaper switcher" 2>/dev/null || true
        exec "$SCRIPT_DIR/theme-switcher.sh" "${1:-}"
    fi

    local choice
    if ! choice=$(rofi_pick); then
        exit 0
    fi

    [ -n "$choice" ] || exit 0
    run_choice "$choice"
}

main "$@"
