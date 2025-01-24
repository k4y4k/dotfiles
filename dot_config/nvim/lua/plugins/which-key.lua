local wk = require("which-key")

-- TODO: a command that clears search

wk.add({
  { "<leader>k", group = "kayak" },
  {
    "<leader>kc",
    require("stay-centered").toggle,
    desc = "Toggle stay-centered",
  },
  { "<leader>k/", "<cmd>gcc<cr>", desc = "toggle line comment" },
  {
    "<leader>ko",
    -- FIXME: needs debugging - sometimes code opens 5 files that are obviously the uninterpreted args
    "<cmd>lua os.execute('code ' .. vim.fn.expand('%:p'))<cr>",
    desc = "open this file in VSCode?",
  },
})

wk.add({
  {
    "<leader>kt",
    "<cmd>Trouble todo toggle pinned=true win.relative=win win.position=right<cr>",
    desc = "toggle todos",
  },
  {
    "<leader>kd",
    "<cmd>Trouble diagnostics toggle pinned=true win.relative=win win.position=bottom<cr>",
    desc = "toggle diag",
  },
})

return {
  {
    -- NOTE: which-key is the menu that pops up when <leader> (in my
    -- case space) is pressed.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "helix" },
  },
}
