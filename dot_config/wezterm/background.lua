local th = require("light_dark_switcher")

local module = {}

function module.choose_bg_image()
  local is_light = th.is_host_light_theme()

  ---@type table
  local background

  if is_light then
    background = {
      {
        source = { Color = "#72d9be" },
        width = "100%",
        height = "100%",
        opacity = 0.5,
        hsb = { saturation = 0.5, brightness = 2 },
      },
      {
        source = {
          File = os.getenv("HOME") .. "/.config/wezterm/" .. "img/bg_l.jpg",
        },
        opacity = 0.6,
      },

      {
        source = { Color = "#fff" },
        opacity = 0.7,
        width = "100%",
        height = "100%",
      },
    }
    return background
  end

  background = {
    {
      source = { Color = "#72d9be" },
      width = "100%",
      height = "100%",
      opacity = 0.5,
      hsb = { saturation = 0.5, brightness = -1 },
    },
    {
      source = {
        File = os.getenv("HOME") .. "/.config/wezterm/" .. "img/bg_d.jpg",
      },
      opacity = 0.6,
    },

    {
      source = { Color = "#111" },
      opacity = 0.7,
      width = "100%",
      height = "100%",
    },
  }

  return background
end

return module
