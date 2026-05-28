---- KEYBINDINGS ---

local vars = require("conf.vars")

local terminal = vars.terminal
local fileManager = vars.fileManager
local menu = vars.menu
local browser = vars.browser
local mainMod = vars.mainMod
local screenshot = "~/.config/hypr/scripts/screenshot.sh"

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- closeWindowBind:set_enabled(false)

-- Workspace overview (rofi window switcher)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/workspace-overview.sh"))

-- System actions menu
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/system-menu.sh"))

-- Quick calculator
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("~/.config/hypr/scripts/rofi-calc.sh"))

-- Directory jumper
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/dir-jumper.sh"))

-- Quick note
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/quick-note.sh"))

-- Gaming mode toggle
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/gaming-mode.sh"))

-- Waybar visibility toggle
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-waybar.sh"))

hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl eval 'hl.dispatch(hl.dsp.exit())'")
)

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

hl.bind("Print", hl.dsp.exec_cmd(screenshot .. " full"), { locked = true })

hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(screenshot .. " area"), { locked = true })
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move window in direction
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize window in direction (continuous while held)
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

-- Clipboard history (requires cliphist)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' -theme /home/tharoon/.config/rofi/clipboard.rasi -display-columns 2 | cliphist decode | wl-copy"))

-- Control Center toggle
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-control-center.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-control-center.sh"))

-- Color picker
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Emoji picker
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))

-- Cycle through recent windows
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next())

-- Cycle through workspaces 1-10 in a loop
hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "e+1" }))

-- Resize mode toggle
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/resize-mode.sh"))

-- Switch layout between dwindle and master
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-layout.sh"))

-- Power menu (wlogout)
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("~/.config/hypr/scripts/power-menu.sh"))

-- Move window with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness (with OSD notifications)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-notify.sh up"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-notify.sh down"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-notify.sh mute"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

-- Theme hub (wallpaper, palette, presets)
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/theme-menu.sh"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-switcher.sh --cycle-mode"))
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-preset-switcher.sh"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-notify.sh up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-notify.sh down"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, repeating = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, repeating = true })
