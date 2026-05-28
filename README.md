# Arch Hyprland Dotfiles

This repository contains my personal Arch Linux + Hyprland configuration files, scripts, and wallpaper collection.

## Setup
To install these dotfiles and the required packages, use the provided installer script:

```bash
./install.sh
```

The script will:
1. Update your system using `pacman`.
2. Automatically detect and use an AUR helper (`paru` or `yay`) if available, or fall back to `pacman`.
3. Copy all configuration files to `~/.config/`.
4. Copy wallpapers to `~/wallpaper/`.

## Structure
- `.config/`: Configuration files for various applications (Hyprland, Waybar, Nvim, etc.).
- `wallpaper/`: A collection of my wallpapers.
- `pkglist.txt`: A list of currently installed packages to maintain system parity.
- `install.sh`: The automated installer script.
