#!/bin/bash
# Wallpaper script — managed by vsHyprland-Manager
sleep 1
awww-daemon &
sleep 0.5
awww img "/home/tharoon/.config/hypr/current_wallpaper" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1.0

# Generate dynamic colors
matugen image "/home/tharoon/.config/hypr/current_wallpaper"
