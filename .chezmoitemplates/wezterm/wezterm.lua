local wezterm = require("wezterm")
local config = wezterm.config_builder()
local light_dark_switcher = require("light_dark_switcher")

--- Returns the battery segment.
--- If no battery (like a desktop), returns ""
--- If there's more than an hour of charging/discharging left to go, returns [⚡️|🔋|☕️] xx% (YhZm)
--- If there's exactly an hour of charging/discharging left to go, returns [⚡️|🔋|☕️] xx% (1h)
--- If there's less than an hour, returns [⚡️|🔋|☕️] xx% (Z min)
---
--- @return string
local function battery_segment()
	local battery = wezterm.battery_info()[1]

	if not battery then
		return ""
	end

	--[[
		Use an icon to show the state of the battery.
		⚡️ - charging
		🔋 - discharging
		☕️ - plugged in
		empty string if no battery found
	]]
	local icon = ""

	if battery.state == "Charging" then
		icon = wezterm.nerdfonts.fa_bolt
	elseif battery.state == "Discharging" then
		icon = wezterm.nerdfonts.fa_battery_empty
	else
		icon = ""
	end

	if battery.state == "Full" then
		return wezterm.nerdfonts.fa_coffee .. " 100%"
	end

	local juice = string.format("%.0f%%", (battery.state_of_charge * 100) + 1)

	wezterm.log_info(battery)

	-- Could be time to 100% or time to 0%. Context specific.
	--- @type string
	local time = ""

	if battery.time_to_full then
		time = string.format("%.0f", battery.time_to_full / 60)
	elseif battery.time_to_empty then
		time = string.format("%.0f", battery.time_to_empty / 60)
	end

	-- if time is 65535, it means it's infinity! yippee! 🎉
	-- ...which means that the ETA hasn't been calculated yet. aw... 😔
	if time == 65535 then
		time = "∞"
	end

	-- if time > 60 then it's x hours x minutes
	if tonumber(time) > 60 then
		time = string.format("%.0fh%.0fm", time / 60, time % 60)
	elseif tonumber(time) == 60 then
		time = "1h"
	else -- if time < 60 then it's x minutes
		time = time .. " min"
	end

	return icon .. " " .. juice .. " " .. "(" .. time .. ")"
end

local function get_platform()
	local platform = wezterm.target_triple

	if platform:find("windows") then
		platform = "windows"
	elseif platform:find("darwin") then
		platform = "macos"
	elseif platform:find("linux") then
		platform = "linux"
	else
		platform = "unknown"
	end

	return platform
end

---@type table
local fontList = {
	-- "Server Mono",
	{ family = "Monaspace Argon", weight = "Medium" },
	"JetBrainsMono Nerd Font Mono",
}

config.font = wezterm.font_with_fallback(fontList)

if get_platform() == "macos" then
	config.font_size = 14
	config.line_height = 1.15
end

-- FIXME - make compatible with random themes
if light_dark_switcher.is_host_light_theme() then
	config.color_scheme = "Catppuccin Latte"
else
	config.color_scheme = "Catppuccin Mocha"
end

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.window_background_opacity = 0.80
config.macos_window_background_blur = 15

config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	-- font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
	font_size = 12,
	font = wezterm.font_with_fallback(fontList),
}

--- @return table
local function segments_for_right_status()
	local ideal = {
		--	wacky_mode.compose_segment(),

		get_platform() == "macos" and wezterm.nerdfonts.fa_apple
			or get_platform() == "windows" and wezterm.nerdfonts.fa_windows
			or get_platform() == "linux" and wezterm.nerdfonts.fa_linux
			or "",

		battery_segment(),
		-- TODO: hide icons if too squished
		wezterm.nerdfonts.fa_clock_o
			.. " "
			.. wezterm.strftime("%H:%M"),
		wezterm.nerdfonts.fa_calendar_o .. " " .. wezterm.strftime("%d %b %Y (%a)"),
	}

	return ideal
end

wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status()

	local color_scheme = window:effective_config().resolved_palette

	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	---@diagnostic disable-next-line: unbalanced-assignments - It seems to work
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

return config
