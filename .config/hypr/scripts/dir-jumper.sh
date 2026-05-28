#!/usr/bin/env bash

if command -v zoxide &>/dev/null; then
  dir=$(zoxide query -l 2>/dev/null | rofi -dmenu -p "  Dir (zoxide)" -theme ~/.config/rofi/dir-jumper.rasi -i)
  [[ -z "$dir" ]] && exit 0
  kitty --working-directory "$dir" --title "$(basename "$dir")"
else
  cache="$HOME/.cache/dir-jumper"

  mkdir -p "$(dirname "$cache")"

  if [[ ! -f "$cache" ]] || [[ $(find "$cache" -mmin +5) ]]; then
    {
      find "$HOME" -maxdepth 3 -type d 2>/dev/null | grep -vE '(\.git|node_modules|\.cache|\.local/share|\.mozilla|\.config/google-chrome)'
      find "$HOME/Documents" "$HOME/Projects" "$HOME/dev" "$HOME/work" -maxdepth 4 -type d 2>/dev/null
    } | sort -u > "$cache"
  fi

  dir=$(cat "$cache" | rofi -dmenu -p "  Dir" -theme ~/.config/rofi/dir-jumper.rasi -i)

  [[ -z "$dir" ]] && exit 0

  kitty --working-directory "$dir" --title "$(basename "$dir")"
fi
