local wezterm = require("wezterm")
local module = {}

--- Returns the battery segment.
--- @return string
function module.battery_segment()
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
	elseif battery.state == "Full" then
		icon = wezterm.nerdfonts.fa_coffee
	else
		icon = ""
	end

	local juice = string.format("%.0f%%", battery.state_of_charge * 100)

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

return module
