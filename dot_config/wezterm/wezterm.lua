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
end

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 15

config.window_frame = {
  font_size = 12,
  font = wezterm.font_with_fallback(fontList),
}

local function naiveHostnameFixes(string)
  ---@type string
  local res = "" .. string

  res = res.gsub(res, ".local", "")

  return res
end

---@return string # [icon?] user@host
local function user_segment()
  ---@type string
  local icon = get_platform() == "macos" and wezterm.nerdfonts.fa_apple
    or get_platform() == "windows" and wezterm.nerdfonts.fa_windows
    or get_platform() == "linux" and wezterm.nerdfonts.fa_linux
    -- TODO: what happens when no icon?
    or ""

  ---@type string
  local hostname = naiveHostnameFixes(wezterm.hostname())

  local username = os.getenv("USER")
    or os.getenv("LOGNAME")
    or os.getenv("USERNAME")

  local res = icon .. " " .. username .. "@" .. hostname

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

--- @return table
local function segments_for_right_status()
  local ideal = {

    user_segment(),

    battery_segment.battery,

    -- TODO: hide icons if too squished
    -- wezterm.nerdfonts.fa_clock_o
    --   .. " "
    --   .. wezterm.strftime("%H:%M:%S"),
    clock_blinking_seperators(),

    wezterm.nerdfonts.fa_calendar_o .. " " .. wezterm.strftime(
      "%d %b|%m %Y (%a)"
    ),
  }

  return ideal
end

wezterm.on("update-status", function(window, _)
  ---@diagnostic disable-next-line: undefined-global -- it works
  local SOLID_LEFT_ARROW = utf8.char(0xe0b6)

  ---@type string[]
  local segments = segments_for_right_status()

  local color_scheme = window:effective_config().resolved_palette

  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  ---@diagnostic disable-next-line: unbalanced-assignments - It seems to work
  local gradient_to, gradient_from = bg

  if light_dark_switcher.is_host_light_theme() then
    gradient_from = gradient_to:darken(0.2):adjust_hue_fixed(-15)
  else
    gradient_from = gradient_to:lighten(0.2):adjust_hue_fixed(15)
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
    local is_first = i == 1

    ---@type boolean # is the last character already a space?
    local shouldAddSpace = seg.sub(seg, -1) ~= " "

    if is_first then
      table.insert(elements, { Background = { Color = "none" } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i] } })

    if shouldAddSpace then
      table.insert(elements, { Text = "" .. seg .. " " })
    else
      table.insert(elements, { Text = "" .. seg .. "" })
    end
  end

  window:set_right_status(wezterm.format(elements))
end)

return config
