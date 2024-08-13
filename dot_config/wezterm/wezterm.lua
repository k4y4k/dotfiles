-- Import wezterm
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- (Config goes here...)
wezterm.log_info("hewo... i am " .. wezterm.hostname())

return config
