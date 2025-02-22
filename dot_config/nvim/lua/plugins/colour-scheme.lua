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
  { "dracula/vim", name = "dracula" },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("catppuccin")

      c.setup({
        integrations = {
          ts_rainbow = true,
        },
        color_overrides = {
          mocha = {
            text = "#F4CDE9",
            subtext1 = "#DEBAD4",
            subtext0 = "#C8A6BE",
            overlay2 = "#B293A8",
            overlay1 = "#9C7F92",
            overlay0 = "#866C7D",
            surface2 = "#705867",
            surface1 = "#5A4551",
            surface0 = "#44313B",

            base = "#352939",
            mantle = "#211924",
            crust = "#1a1016",
          },
        },
      })
    end,
  },

  { "ajmwagar/vim-deus" },

  { "NLKNguyen/papercolor-theme" },

  { "nyoom-engineering/oxocarbon.nvim" },

  { "pineapplegiant/spaceduck" },

  { "rebelot/kanagawa.nvim" },

  {
    "junegunn/seoul256.vim",

    config = function()
      vim.g.seoul256_srgb = 1
    end,
  },

  {
    -- wake up, samurai...
    "maxmx03/fluoromachine.nvim",

    config = function()
      local fm = require("fluoromachine")

      fm.setup({
        glow = true,
        theme = "fluoromachine",
        transparent = false,
      })

      -- INVESTIGATE: lualine matches if this theme is selected, otherwise does whatever it does already
      -- local lualine = require("lualine")

      -- lualine.setup({ options = {
      --   theme = "fluoromachine",
      -- } })
    end,
  },

  { "rktjmp/lush.nvim", lazy = false },

  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      --  TODO: add it to the list
    end,
  },

  { "LazyVim/LazyVim", opts = { colorscheme = "oxocarbon" } },
}
