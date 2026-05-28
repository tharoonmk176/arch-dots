#!/usr/bin/env bash

bat=$(cat /sys/class/power_supply/BAT1/capacity)
stat=$(cat /sys/class/power_supply/BAT1/status)

if [ "$stat" = "Charging" ]; then
    echo "󰂄"
    exit 0
fi

if [ "$bat" -gt 90 ]; then echo "󰁹"
elif [ "$bat" -gt 80 ]; then echo "󰂂"
elif [ "$bat" -gt 70 ]; then echo "󰂁"
elif [ "$bat" -gt 60 ]; then echo "󰂀"
elif [ "$bat" -gt 50 ]; then echo "󰁿"
elif [ "$bat" -gt 40 ]; then echo "󰁾"
elif [ "$bat" -gt 30 ]; then echo "󰁽"
elif [ "$bat" -gt 20 ]; then echo "󰁼"
elif [ "$bat" -gt 10 ]; then echo "󰁻"
else echo "󰁺"
fi
