------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "1920x1080@144",
	position = "auto",
	scale = "1.25",
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})
