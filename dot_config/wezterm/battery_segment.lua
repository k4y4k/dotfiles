local wezterm = require("wezterm")
local module = {}

-- NOTE: I don't own a machine that has 2 batteries.
-- They could exist I spose but this tab assumes the first battery
-- is the important one

---@return string
local function maybe_add_estimate()
  local battery = wezterm.battery_info()[1]
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

  if time == 0 then
    return ""
  end

  if time == nil or tonumber(time) == nil then
    return ""
  end

  -- if time > 60 then it's x hours x minutes
  if tonumber(time) > 60 then
    time = string.format("%.0fh%.0fm", time / 60, time % 60)
  -- exactly 60 minutes should show as "1h"
  elseif tonumber(time) == 60 then
    time = "1h"
  else -- if time < 60 then it's x minutes
    time = time .. " min"
  end

  return " (" .. time .. ")"
end

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
  end

  if battery.state == "Unknown" then
    icon = wezterm.nerdfonts.fa_question
  end

  if battery.state == "Discharging" then
    icon = wezterm.nerdfonts.fa_arrow_down
  end

  if battery.state == "Discharging" and battery.state_of_charge < 0.20 then
    icon = wezterm.nerdfonts.fa_exclamation
  end

  if icon ~= "" then
    icon = icon .. " "
  end

  -- [[
  -- Wezterm doesn't show that a degraded/old battery at 100% is "Full"
  -- so there's a bit of massaging that has to take place
  -- ]]
  if
    battery.state == "Full"
    or (battery.state ~= "Discharging" and battery.time_to_full == 0)
  then
    return wezterm.nerdfonts.fa_coffee .. " 100%"
  end

  local juice = string.format("%.0f%%", (battery.state_of_charge * 100))
  local estimate = maybe_add_estimate()

  return icon .. juice .. estimate
end

module.battery = battery_segment()

return module
