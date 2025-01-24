-- NOTE: light mode 6am -> 6pm, dark otherwise
local hour = os.date("%H")
local minute = os.date("%M")

-- Rise and grind (coffee), we're using light theme at 6AM
local function isBeforeStartOfDay()
  if tonumber(hour) <= 6 then
    return true
  end

  return false
end

-- Take a break... it's 5:30PM
local function isAfterEndOfDay()
  local wasHalfPast = tonumber(minute) > 29

  if (tonumber(hour) == 17 and wasHalfPast) or tonumber(hour) > 17 then
    return true
  end

  return false
end

local function maybeChangeBG()
  local status = ""

  if isBeforeStartOfDay() or isAfterEndOfDay() then
    print("STILL GRINDING ?")

    vim.o.background = "dark"
  else
    print("another cup of tea...")
    vim.o.background = "light"
  end
end

local timer = vim.loop.new_timer()

timer:start(0, (1000 * 60 * 10), vim.schedule_wrap(maybeChangeBG))

local colMenu = "<leader>kC"

local wk = require("which-key")
wk.add({
  { colMenu .. "?", "<cmd>colorscheme<cr>", desc = "what theme is THIS?!" },
  { colMenu .. "/", "<cmd> set background=dark<cr>", desc = "dark bg" },
  { colMenu .. ".", "<cmd> set background=light<cr>", desc = "light bg" },

  ---

  { colMenu .. "o", "<cmd>colorscheme oxocarbon<cr>", desc = "oxocarbon" },
  { colMenu .. "e", "<cmd>colorscheme everforest<cr>", desc = "everforest" },
})

return {

  -- COLOUR SCHEMES

  {
    "sainnhe/everforest",
    -- lazy = false,
    -- priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      --  TODO: add it to the list
    end,
  },

  {
    "BrunoCiccarino/nekonight",
    lazy = false,
    priority = 1000,
    -- opts = {},
  },

  { "nyoom-engineering/oxocarbon.nvim" },

  { "LazyVim/LazyVim", opts = { colorscheme = "everforest" } },
}
