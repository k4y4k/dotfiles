local wezterm = require("wezterm")
local choose_theme = require("choose_theme")
local config = wezterm.config_builder()
local light_dark_switcher = require("light_dark_switcher")
local style_debug = require("style_debug")
local battery_segment = require("battery_segment")
local user_segment = require("user_segment")

--- Whether to enable the style debug tabs
--- (can use a lot of space)
---@type boolean
local enable_style_debug = true

config.use_fancy_tab_bar = false
config.use_cap_height_to_scale_fallback_fonts = true

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
  { family = "RecMonoCasual Nerd Font Mono" },
  { family = "Monaspace Argon", weight = "Medium" },
  "JetBrainsMono Nerd Font Mono",
}

config.font = wezterm.font_with_fallback(fontList)

-- NOTE: macos-only tweaks (retina vs regular LCD)
if get_platform() == "macos" then
  config.font_size = 13
  config.line_height = 1.10
end

config.color_scheme = choose_theme.choose_colour_theme()

config.window_background_opacity = 0.85
config.macos_window_background_blur = 15

local tab_font = wezterm.font("Victor Mono", {
  style = "Italic",
  weight = "Bold",
})

config.window_frame = {
  font = tab_font,
  font_size = 12,
}

config.tab_max_width = 99

config.window_decorations = "NONE"

if string.lower(tostring(get_platform())) == "linux" then
  local is_gnome = tostring(os.getenv("DESKTOP_SESSION")) == "gnome" or nil

  if is_gnome then
    config.window_decorations = "RESIZE"
  end
end

if get_platform() == "macos" then
  config.window_frame = { font_size = 11, font = tab_font }
  config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
end

---@return string
local function clock_blinking_seperators()
  local sec = wezterm.strftime("%S")
  local doShowDots = sec % 2 == 0

  ---@type string
  local res = wezterm.strftime("%H:%M")

  if doShowDots then
    res = res.gsub(res, ":", " ")
  end

  return wezterm.nerdfonts.fa_clock_o .. " " .. res
end

wezterm.on("update-status", function(window, _)
  ---@type string[]
  local segments = {
    user_segment.user_host(),
    clock_blinking_seperators(),
    wezterm.nerdfonts.fa_calendar_o .. " " .. wezterm.strftime("%d %b %Y"),
    wezterm.nerdfonts.fa_hand_peace_o .. " " .. wezterm.strftime("%a"),
  }

  -- NOTE: battery segment on macos but not linux
  -- TODO: make dependent on battery existing
  if get_platform() == "macos" then
    segments = { battery_segment.battery, table.unpack(segments) }
  end

  if enable_style_debug then
    segments = {
      style_debug.theme_name(),
      style_debug.theme_tab(),
      table.unpack(segments),
    }
  end

  local color_scheme = window:effective_config().resolved_palette

  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  ---@diagnostic disable-next-line: unbalanced-assignments - It seems to work
  local gradient_to, gradient_from = bg

  if light_dark_switcher.is_host_light_theme() then
    gradient_from = gradient_to:darken(0.2):adjust_hue_fixed(45)
  else
    gradient_from = gradient_to:lighten(0.1):adjust_hue_fixed(-45)
  end

  local gradient = wezterm.color.gradient(
    {
      orientation = "Horizontal",
      colors = { gradient_from, gradient_to },
    },
    #segments -- only gives us as many colours as we have segments.
  )

  local elements = {}

  for i, seg in ipairs(segments) do
    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i] } })

    table.insert(elements, { Text = " " .. seg .. " " })
  end

  window:set_right_status(wezterm.format(elements))
end)

config.background = require("background").choose_bg_image()

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

return config
