local wezterm = require("wezterm")
local ght = require("get_host_theme")
local module = {}

---@return string
function module.choose_colour_theme()
  local res

  if ght.get_host_theme() then
    res = "Atelier Savanna Light (base16)"
  else
    res = "Atelier Savanna (base16)"
  end

  return res
end

return module
