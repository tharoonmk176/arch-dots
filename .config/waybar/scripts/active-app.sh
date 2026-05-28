#!/usr/bin/env bash
# Active window class — never return empty (avoids waybar icon error)

class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // .initialClass // empty' 2>/dev/null)
class=${class:-—}

printf '{"text":"%s","tooltip":"%s","class":"app"}\n' "${class:0:18}" "$class"
