-- Loads ~/.config/hypr/colors.conf (theme presets + matugen both write here)

local path = os.getenv("HOME") .. "/.config/hypr/colors.conf"

local function parse_conf(file_path)
	local colors = {
		background          = "rgba(121316ff)",
		surface             = "rgba(1e2023ff)",
		foreground          = "rgba(89b4faff)",
		readable_foreground = "rgba(e3e2e6ff)",
		primary             = "rgba(89b4faff)",
		secondary           = "rgba(bcc7deff)",
		tertiary            = "rgba(eab5ecff)",
		accent              = "rgba(595959aa)",
		error               = "rgba(ffb4abff)",
	}

	local f = io.open(file_path, "r")
	if not f then
		return colors
	end

	for line in f:lines() do
		local key, value = line:match("^%$([%w_]+)%s*=%s*(.+)$")
		if key and value then
			value = value:gsub("^%s+", ""):gsub("%s+$", "")
			if colors[key] ~= nil then
				colors[key] = value
			end
		end
	end
	f:close()

	if colors.accent == "rgba(595959aa)" and colors.primary then
		colors.accent = colors.primary
	end

	return colors
end

local c = parse_conf(path)

return {
	background = c.background,
	surface = c.surface,
	foreground = c.foreground,
	readable = c.readable_foreground,
	primary = c.primary,
	secondary = c.secondary,
	tertiary = c.tertiary,
	accent = c.accent,
	error = c.error,
}
