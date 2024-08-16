local wezterm = require("wezterm")
local module = {}

-- local colour_themes = {}
-- for name, theme in pairs(wezterm.color.get_builtin_schemes()) do
-- table.insert(colour_themes, name)
-- end

-- -- When the config is reloaded (config save, new window opened...)
-- wezterm.on("window-config-reloaded", function(window, pane)
-- if window:get_config_overrides() then
-- return
-- end

-- local theme = colour_themes[math.random(#colour_themes)]
-- window:set_config_overrides({ color_scheme = theme })
-- wezterm.log_info("Colour theme: " .. theme)
-- end)

function module.sayHi()
	return "WACKY MODE"
end

return module
