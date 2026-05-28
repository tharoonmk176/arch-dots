-- Float utility windows
hl.window_rule({
  name  = "float-pavucontrol",
  match = { class = "pavucontrol" },
  float = true,
})
hl.window_rule({
  name  = "float-pcmanfm-qt",
  match = { class = "Pcmanfm-qt" },
  float = true,
})
hl.window_rule({
  name  = "float-blueman",
  match = { class = "blueman-manager" },
  float = true,
})
hl.window_rule({
  name  = "float-qt5ct",
  match = { class = "qt5ct" },
  float = true,
})
hl.window_rule({
  name  = "float-gtk-orphan",
  match = { class = "Gtk orphan" },
  float = true,
})
hl.window_rule({
  name  = "float-polkit",
  match = { class = "polkit-gnome-authentication-agent-1" },
  float = true,
})
hl.window_rule({
  name  = "float-pinentry",
  match = { class = "pinentry-gtk-2" },
  float = true,
})
hl.window_rule({
  name  = "float-imv",
  match = { class = "imv" },
  float = true,
})
hl.window_rule({
  name  = "float-mpv",
  match = { class = "mpv" },
  float = true,
})
hl.window_rule({
  name  = "float-xarchiver",
  match = { class = "Xarchiver" },
  float = true,
})
hl.window_rule({
  name  = "float-file-roller",
  match = { class = "file-roller" },
  float = true,
})
hl.window_rule({
  name  = "float-gnome-calculator",
  match = { class = "gnome-calculator" },
  float = true,
})
hl.window_rule({
  name  = "float-gnome-calendar",
  match = { class = "gnome-calendar" },
  float = true,
})
hl.window_rule({
  name  = "float-firefox-splash",
  match = { title = "Firefox - Sharing Indicator" },
  float = true,
})
hl.window_rule({
  name  = "float-jetbrains-toolbox",
  match = { title = "jetbrains-toolbox" },
  float = true,
})
hl.window_rule({
  name  = "float-vesktop-overlay",
  match = { title = "Vesktop" },
  float = true,
})

-- Workspace assignment rules
-- hl.window_rule({
--   name  = "workspace-browser",
--   match = { class = "google-chrome" },
--   workspace = "2",
-- })
hl.window_rule({
  name  = "workspace-filemanager",
  match = { class = "Pcmanfm-qt" },
  workspace = "3",
})
hl.window_rule({
  name  = "workspace-discord",
  match = { class = "vesktop" },
  workspace = "4",
})

-- If rofi spawns as a window instead of a layer, apply fade animation
hl.window_rule({
	name = "rofi-window-anim",
	match = { class = "^[Rr]ofi$" },
	animation = "fade",
})
