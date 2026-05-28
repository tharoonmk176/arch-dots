-- Blur and polish for overlays (rofi, notifications, logout, bar)

local blur_layers = {
	"rofi",
	"waybar",
	"swaync-notification-window",
	"notifications",
	"wlogout",
	"hyprlock",
	"gtk-layer-shell",
	"osd",
	"control_center",
}

for _, ns in ipairs(blur_layers) do
	hl.layer_rule({
		name = "blur-" .. ns,
		match = { namespace = ns },
		blur = true,
	})
end

hl.layer_rule({
	name = "no-blur-swaync",
	match = { namespace = "swaync-control-center" },
	blur = false,
})

hl.layer_rule({
	name = "no-blur-swaync-notif",
	match = { namespace = "swaync-notification-window" },
	blur = false,
})

hl.layer_rule({
	name = "no-blur-screenshot",
	match = { namespace = "grimblast" },
	blur = false,
})

-- Fix Rofi animations
hl.layer_rule({
	name = "anim-rofi",
	match = { namespace = "rofi" },
	animation = "fade",
})

-- Apply animation to standard rofi class
hl.layer_rule({
	name = "anim-rofi-fallback",
	match = { namespace = "^rofi$" },
	animation = "fade",
})
