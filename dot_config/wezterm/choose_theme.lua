local wezterm = require("wezterm")
local light_dark_switcher = require("light_dark_switcher")
local module = {}

---@return string
function module.choose_colour_theme()
  local res

  if light_dark_switcher.is_host_light_theme() then
    res = "Atelier Savanna Light (base16)"
  else
    res = "Atelier Savanna (base16)"
  end

  return res
end

return module
