local w = require("wezterm")
local module = {}

local function naiveHostnameFixes(string)
  ---@type string
  local res = "" .. string

  res = res.gsub(res, ".local", "")

  return res
end

---@return string # [icon?] user@host
function module.user_host()
  ---@type string
  local hostname = naiveHostnameFixes(w.hostname())

  local username = os.getenv("USER")
    or os.getenv("LOGNAME")
    or os.getenv("USERNAME")

  local res = w.nerdfonts.fa_user_circle .. " " .. username .. "@" .. hostname

  return res
end

return module
