#!/usr/bin/env bash

mkdir -p "$HOME/notes"
note_file="$HOME/notes/quicknotes.md"

mode=$(echo -e "add\nview\nedit" | rofi -dmenu -p "Note Mode" -theme ~/.config/rofi/calc.rasi)

case "$mode" in
  add)
    note=$(rofi -dmenu -p "Note" -theme ~/.config/rofi/calc.rasi)
    [[ -z "$note" ]] && exit 0
    echo "- $(date '+%Y-%m-%d %H:%M') — $note" >> "$note_file"
    count=$(wc -l < "$note_file")
    notify-send "Note saved" "$count lines total"
    ;;
  view)
    [[ -f "$note_file" ]] || { notify-send "No notes" "Create one first"; exit 0; }
    cat "$note_file" | rofi -dmenu -p "Notes" -theme ~/.config/rofi/calc.rasi
    ;;
  edit)
    [[ -f "$note_file" ]] || { touch "$note_file"; }
    kitty -e nvim "$note_file"
    ;;
  *)
    exit 0
    ;;
esac
