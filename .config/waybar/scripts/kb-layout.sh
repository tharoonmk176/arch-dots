#!/usr/bin/env bash
# Keyboard layout from Hyprland (JSON)

kb=$(hyprctl devices -j 2>/dev/null | jq -r '.keyboards[0].main_layout // .keyboards[0].active_keymap // "us"' 2>/dev/null)
kb=${kb:-us}

# Shorten "English (US)" style names
if [[ "$kb" == *"("* ]]; then
    short=$(echo "$kb" | sed -n 's/.*(\([^)]*\)).*/\1/p')
    [ -n "$short" ] && kb=$short
fi
kb=$(echo "$kb" | tr '[:lower:]' '[:upper:]' | head -c 5)

printf '{"text":"󰌌 %s","tooltip":"Layout: %s — click to cycle","class":"kb"}\n' "$kb" "$kb"
