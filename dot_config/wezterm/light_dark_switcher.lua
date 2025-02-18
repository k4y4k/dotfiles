local wezterm = require("wezterm")
local module = {}

-- Is the host OS in light mode? defaults to yes unless we can
-- specifically detect otherwise
function module.is_host_light_theme()
  if wezterm.gui then
    print("[light_dark_switcher] wezterm.gui OK")
    -- if wezterm is available and can detect such things:
    -- is it light theme in here?

    local appearance = wezterm.gui.get_appearance()

    print("local `appearance` is " .. tostring(appearance))

    return appearance:find("Light")
  end

  -- if wezterm is not available, or cannot find out, we'll default to
  -- light theme anyway
  return true
end

return module
