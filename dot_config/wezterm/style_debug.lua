local wezterm = require("wezterm")
local light_dark_switcher = require("light_dark_switcher")
local ct = require("choose_theme")
local module = {}

--- Utility tabs for showing
--- the current theme name;
--- current system theme (light/dark mode?);

--- 🖌️"light"|"dark"
---@return string
function module.theme_tab()
  local check = light_dark_switcher.is_host_light_theme()
  ---@type string
  local res

  if check then
    res = "light"
  else
    res = "dark"
  end

  return wezterm.nerdfonts.fa_paint_brush .. " " .. res
end

---@return string
function module.theme_name()
  local res = "theme_name()"

  res = ct.choose_colour_theme()

  return wezterm.nerdfonts.fa_camera_retro .. " " .. res
end

return module
