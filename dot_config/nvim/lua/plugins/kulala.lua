return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  keys = {
    { "<leader>R", "", desc = "+Rest", ft = "http" },
    {
      "<leader>Rb",
      "<cmd>lua require('kulala').scratchpad()<cr>",
      desc = "Open scratchpad",
      ft = "http",
    },
    {
      "<leader>Rc",
      "<cmd>lua require('kulala').copy()<cr>",
      desc = "Copy as cURL",
      ft = "http",
    },
    {
      "<leader>RC",
      "<cmd>lua require('kulala').from_curl()<cr>",
      desc = "Paste from curl",
      ft = "http",
    },
    {
      "<leader>Rg",
      "<cmd>lua require('kulala').download_graphql_schema()<cr>",
      desc = "Download GraphQL schema",
      ft = "http",
    },
    {
      "<leader>Ri",
      "<cmd>lua require('kulala').inspect()<cr>",
      desc = "Inspect current request",
      ft = "http",
    },
    {
      "<leader>Rn",
      "<cmd>lua require('kulala').jump_next()<cr>",
      desc = "Jump to next request",
      ft = "http",
    },
    {
      "<leader>Rp",
      "<cmd>lua require('kulala').jump_prev()<cr>",
      desc = "Jump to previous request",
      ft = "http",
    },
    {
      "<leader>Rq",
      "<cmd>lua require('kulala').close()<cr>",
      desc = "Close window",
      ft = "http",
    },
    {
      "<leader>Rr",
      "<cmd>lua require('kulala').replay()<cr>",
      desc = "Replay the last request",
      ft = "http",
    },
    {
      "<leader>R.",
      "<cmd>lua require('kulala').run()<cr>",
      desc = "Send the request",
      ft = "http",
    },
    {
      "<leader>RS",
      "<cmd>lua require('kulala').show_stats()<cr>",
      desc = "Show stats",
      ft = "http",
    },
    {
      "<leader>Rt",
      "<cmd>lua require('kulala').toggle_view()<cr>",
      desc = "Toggle headers/body",
      ft = "http",
    },
  },
  opts = {

    ui = {
      -- display mode: possible values: "split", "float"
      display_mode = "float",
      -- split direction: possible values: "vertical", "horizontal"
      split_direction = "vertical",
      -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
      default_view = "body",
      -- enable winbar
      winbar = true,
      -- Specify the panes to be displayed by default
      -- Current available pane contains { "body", "headers", "headers_body", "script_output", "stats", "verbose" },
      default_winbar_panes = { "body", "headers", "headers_body", "verbose" },
      -- enable/disable variable info text
      -- this will show the variable name and value as float
      -- possible values: false, "float"
      show_variable_info_text = false,
      -- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
      show_icons = "on_request",
      -- default icons
      icons = {
        inlay = {
          loading = "🤔",
          done = "🆗",
          error = "❌",
        },
        lualine = "🐼",
        textHighlight = "WarningMsg", -- highlight group for request elapsed time
        lineHighlight = "Normal", -- highlight group for icons line highlight
      },
      -- enable/disable request summary in the output window
      show_request_summary = true,
      summaryTextHighlight = "Special",
    },
  },
}
