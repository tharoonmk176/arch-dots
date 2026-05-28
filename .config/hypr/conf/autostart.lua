hl.on("hyprland.start", function()
	--- Wallpaper (awww)
	hl.exec_cmd("~/.config/hypr/scripts/wallpaper.sh")

	--- Status bar
	hl.exec_cmd("waybar")

	--- Notifications (swaync enabled)
	hl.exec_cmd("swaync")

	--- Idle / lock
	hl.exec_cmd("hypridle")

	--- Clipboard history
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	--- Polkit agent
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

	--- Desktop portal
	hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")

	--- Eww Widgets
	hl.exec_cmd("eww daemon")

	--- Lock on startup (simulated login screen)
	hl.exec_cmd("hyprlock")

	--- Removable drives tray
	hl.exec_cmd("udiskie --no-automount --tray")
	--- Night light
	hl.exec_cmd("gammastep")
end)
