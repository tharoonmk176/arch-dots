-- Polished: smooth springs, quick workspace fades, subtle border sweep

hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("snappy", { type = "bezier", points = { { 0.2, 0 }, { 0.2, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("smooth", { type = "spring", mass = 0.9, stiffness = 82, dampening = 14 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 90, bezier = "linear", style = "loop" })
hl.animation({ leaf = "windows", enabled = true, speed = 5.2, spring = "smooth" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.2, spring = "smooth", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.6, bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, spring = "smooth" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.3, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.6, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.2, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.4, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.6, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.2, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 6.5, bezier = "quick" })
