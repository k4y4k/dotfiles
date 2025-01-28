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
  if get_os() == "Linux" then
    -- glyphs are 1 closer to each other (they have a spacing of -1)
    vim.o.guifont = "RecMonoCasual Nerd Font Mono:h10:w-1"
  else
    vim.o.guifont = "RecMonoCasual Nerd Font Mono:h14:w-1"
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
