local wezterm = require("wezterm")
local config = wezterm.config_builder()
local light_dark_switcher = require("light_dark_switcher")

config.font = wezterm.font_with_fallback({
	"Server Mono",
	{ family = "Monaspace Argon", weight = "Medium" },
	"JetBrainsMono Nerd Font Mono",
})

config.font_size = 14
config.line_height = 1.15

if light_dark_switcher.is_host_light_theme() then
	config.color_scheme = "Tokyo Night Day"
else
	config.color_scheme = "Tokyo Night"
end

config.window_background_opacity = 0.85
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.window_frame = {
	font = wezterm.font({ family = "Monaspace Argon", weight = "Bold" }),
	font_size = 11,
}

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wezterm.strftime("%a %b %-d %H:%M"),
		wezterm.hostname(),
	}
end

wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette

	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground


	local gradient_to, gradient_from = bg
	if light_dark_switcher.is_host_light_theme() then
		gradient_from = gradient_to:darken(0.2)
	else
		gradient_from = gradient_to:lighten(0.2)
	end

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

-- wezterm.on("update-status", function(window)
-- local SOLID_L_ARROW = utf8.char(0xe0b2)

-- local effective_theme = window:effective_config().resolved_palette
-- local bg = effective_theme.background
-- local fg = effective_theme.foreground

-- window:set_right_status(wezterm.format({
-- { Background = { Color = "none" } },
-- { Foreground = { Color = bg } },
-- { Text = SOLID_L_ARROW },
-- { Background = { Color = bg } },
-- { Foreground = { Color = fg } },
-- {Text = ' ' .. wezterm.hostname() .. ' '}
-- }))
-- end)

return config
