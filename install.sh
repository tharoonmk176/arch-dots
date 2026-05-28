#!/bin/bash

# Enhanced install script
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Helper to detect AUR helper
if command -v paru &> /dev/null; then
    AUR_HELPER="paru"
elif command -v yay &> /dev/null; then
    AUR_HELPER="yay"
else
    AUR_HELPER="pacman"
fi

echo "Using $AUR_HELPER to install packages..."
xargs -a pkglist.txt sudo $AUR_HELPER -S --noconfirm --needed

echo "Installing configs..."
mkdir -p ~/.config
cp -r .config/* ~/.config/
mkdir -p ~/wallpaper
cp -r wallpaper/* ~/wallpaper/

echo "Installation complete!"
