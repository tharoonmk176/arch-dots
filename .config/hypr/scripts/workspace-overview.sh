#!/usr/bin/env bash

entries=$(hyprctl clients -j | jq -r '
  sort_by(.workspace.id)
  | .[]
  | select(.mapped == true and .hidden == false)
  | "[WS \(.workspace.id)] \(.class) — \(.title | gsub("[\\n\\t]"; " ") | .[0:80])"
  | @text
')

[[ -z "$entries" ]] && exit 1

choice=$(echo "$entries" | rofi -dmenu -p "Window" -theme ~/.config/rofi/workspace-overview.rasi -i -format i)

[[ -z "$choice" ]] && exit 0

addr=$(hyprctl clients -j | jq -r "
  [sort_by(.workspace.id) | .[] | select(.mapped == true and .hidden == false)]
  | .[$choice]
  | .address
")

hyprctl eval "hl.dispatch(hl.dsp.window.focus({ window = \"address:$addr\" }))"
