-- NOTE: this came from a gist:
-- https://gist.github.com/Zbizu/43df621b3cd0dc460a76f7fe5aa87f30
local function get_os()
  local osname

  if jit then
    return jit.os
  end

  local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))

  if fh then
    osname = fh:read()
  end

  return osname or "windows"
end

if vim.g.neovide then
  if get_os():lower() == "linux" then
    -- [INFO] you're not gonna believe this but running 3+ wms leads to issues
    -- first, lets get our bearings
    local get_desktop = tostring(os.getenv("DESKTOP_SESSION")):lower()

    -- print("local `get_desktop` is " .. get_desktop)

    local is_gnome = get_desktop == "gnome"
    local is_xfce = get_desktop == "xfce"

    if is_gnome or is_xfce then
      vim.o.guifont = "Maple Mono" .. ":h12" .. ":w-1"
      vim.opt.linespace = -2
    else -- (i3)
      vim.o.guifont = "Maple Mono" .. ":h10" .. ":w-1"
    end

    vim.g.neovide_hide_mouse_when_typing = true
  else
    -- (darwin)
    vim.o.guifont = "Anomaly Mono" .. ":h15" .. ":w-0"
  end

  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  -- Shadows on floating windows (messages, `:`)
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 50

  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 11.0
  vim.g.neovide_cursor_vfx_particle_density = 7.0
end

return {}
