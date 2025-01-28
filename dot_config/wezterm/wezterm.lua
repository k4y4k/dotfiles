local wezterm = require("wezterm")
local config = wezterm.config_builder()
local light_dark_switcher = require("light_dark_switcher")
local battery_segment = require("battery_segment")

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

if light_dark_switcher.is_host_light_theme() then
  -- LIGHT MODE
  -- TODO: yet to find a light theme that i actually like but this is ok for now
  config.color_scheme = "Atelier Estuary Light (base16)"
else
  -- DARK MODE
  config.color_scheme = "Catppuccin Mocha"
  config.color_scheme = "Atelier Savanna (base16)"
end

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
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

if get_platform() == "macos" then
  config.window_frame = { font_size = 11, font = tab_font }
end

local function naiveHostnameFixes(string)
  ---@type string
  local res = "" .. string

  res = res.gsub(res, ".local", "")

  return res
end

local function choose_icon_os()
  ---@type string
  local icon = get_platform() == "macos" and wezterm.nerdfonts.fa_apple
    or get_platform() == "windows" and wezterm.nerdfonts.fa_windows
    or get_platform() == "linux" and wezterm.nerdfonts.fa_linux
    -- TODO: what happens when no icon?
    or ""

  return icon
end

---@return string # [icon?] user@host
local function user_segment()
  ---@type string
  local hostname = naiveHostnameFixes(wezterm.hostname())

  local username = os.getenv("USER")
    or os.getenv("LOGNAME")
    or os.getenv("USERNAME")

  local res = username .. "@" .. hostname

  return res
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
    user_segment(),
    clock_blinking_seperators(),
    wezterm.nerdfonts.fa_calendar_o .. " " .. wezterm.strftime("%d %b %Y"),
    wezterm.nerdfonts.fa_hand_peace_o .. " " .. wezterm.strftime("%a"),
  }

  -- INVESTIGATE: battery segment on macos but not linux
  if get_platform() == "macos" then
    segments = { battery_segment.battery, table.unpack(segments) }
  end

  local color_scheme = window:effective_config().resolved_palette

  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  ---@diagnostic disable-next-line: unbalanced-assignments - It seems to work
  local gradient_to, gradient_from = bg

  if light_dark_switcher.is_host_light_theme() then
    gradient_from = gradient_to:darken(0.2 * 2):adjust_hue_fixed(-15)
  else
    gradient_from = gradient_to:lighten(0.1):adjust_hue_fixed(-70)
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

return config
