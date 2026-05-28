local C = require("conf.colors-shared")

hl.config({
	general = {
	        gaps_in          = 2,
	        gaps_out         = 2,
	        border_size      = 2,
	        col              = {
	                active_border = {
	                        colors = { C.primary, C.secondary },
	                        angle  = 45,
	                },
	                inactive_border = { colors = { C.surface }, angle = 0 },
	        },
	        resize_on_border = true,
	        allow_tearing    = false,
	        layout           = "dwindle",
	},

	decoration = {
	        rounding           = 0,
		rounding_power     = 3,
		active_opacity     = 0.98,
		inactive_opacity   = 0.85,
		fullscreen_opacity = 1.0,
		dim_inactive       = true,
		dim_strength       = 0.15,

		shadow = {
			enabled      = true,
			range        = 36,
			render_power = 4,
			color        = 0x77000000,
			offset       = { 0, 8 },
		},

		blur = {
		        enabled            = true,
		        size               = 10,
		        passes             = 3,
		        new_optimizations  = true,
		        ignore_opacity     = true,
		        popups             = false,
		        popups_ignorealpha = 0.5,
		        vibrancy           = 0.28,
		        vibrancy_darkness  = 0.42,
		},
	},
})
