local wezterm = require("wezterm")
local module = {}

-- [INFO] get whether the host is light or dark theme.
-- defaults to dark if we cant tell
function module.get_host_theme()
  if wezterm.gui then
    print("[get_host_theme] wezterm.gui OK")
    -- if wezterm is available and can detect such things:
    -- is it light theme in here?

    local appearance = wezterm.gui.get_appearance()

    print("local `appearance` is " .. tostring(appearance))

    local is_light = appearance:find("Light") or nil

    if is_light then
      return true
    end

    return false
  end

  -- if wezterm is not available, or cannot find out, we'll default to
  -- dark theme
  return false
end

return module
