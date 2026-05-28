---- VARIABLES ----

require("conf.vars")

---- MONITORS ----

require("conf.monitor")

---- KEYBINDINGS ----

require("conf.keybindings")

---- CONFIGURATION ------

require("conf.animations")

----- Environment Variables----

require("conf.env")

---- AUTOSTART ----

require("conf.autostart")

---- INPUT ----

require("conf.input")

----  MISC  ----

require("conf.misc")

---- WINDOW RULES ----

require("conf.rules")

---- WINDOWS AND WORKSPACES ----

require("conf.window")

---- LOOK AND FEEL ----

require("conf.appearance")

---- LAYER RULES ----

require("conf.layers")

---- LAYOUTS ----

require("conf.layouts")

----------------------
----- PERMISSIONS -----
-----------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- Smart gaps: flush edges when only one tiled / fullscreen window
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

--- other config-----
