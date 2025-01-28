local wezterm = require("wezterm")
local module = {}

-- Is the host OS in light mode? defaults to yes unless we can
-- specifically detect otherwise
function module.is_host_light_theme()
	if wezterm.gui then
		-- if wezterm is available and can detect such things:
		-- is it light theme in here?
		return wezterm.gui.get_appearance():find("Light")
	end

	-- if wezterm is not available, or cannot find out, we'll default to
	-- light theme anyway
	return true
end

return module
