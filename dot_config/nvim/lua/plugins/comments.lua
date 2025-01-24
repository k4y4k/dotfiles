return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      merge_keywords = true,
      keywords = {
        DONE = {
          icon = "🎉",
          color = "info",
          alt = { "KAYAK", "YIPPEE" },
        },
      },
    },
  },
}
