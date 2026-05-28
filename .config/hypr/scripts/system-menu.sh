#!/usr/bin/env bash

entries="󰖩  Network Manager\n󰂱  Bluetooth\n󰍹  Display Config\n󰓃  Audio Output"

choice=$(echo -e "$entries" | rofi -dmenu -p "System" -theme ~/.config/rofi/system-menu.rasi -i)

case "$choice" in
  *"Network Manager")
    kitty --title "nmtui" nmtui
    ;;
  *"Bluetooth")
    kitty --title "bluetoothctl" bash -c "echo 'Type help for commands'; bluetoothctl"
    ;;
  *"Display Config")
    kitty --title "wlr-randr" bash -c 'wlr-randr; echo; echo "Press enter to exit"; read'
    ;;
  *"Audio Output")
    sinks=$(wpctl status | sed -n '/Sinks:/,/Sink endpoints:/p' | head -n -1 | tail -n +2 | rg '^\s+│\s+\d+\.' | sed 's/^\s*│\s*//;s/\x1b\[[0-9;]*m//g')
    choice=$(echo "$sinks" | rofi -dmenu -p "Audio Output" -theme ~/.config/rofi/system-menu.rasi -i -format i)
    [[ -z "$choice" ]] && exit 0
    sink_id=$(echo "$sinks" | sed -n "$((choice + 1))p" | rg -oP '^\d+')
    wpctl set-default "$sink_id"
    notify-send "Audio Output" "Switched to sink $sink_id"
    ;;
esac
