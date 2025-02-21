vim.o.wrap = true

return {
  { "folke/drop.nvim" },

  { "eliseshaffer/darklight.nvim" },

  {
    -- NOTE: does what it says on the tin. Any movement except clicking
    -- will typewriter scroll the view
    "arnamak/stay-centered.nvim",
    opts = { enabled = false },
  },
}
