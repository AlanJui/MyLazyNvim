return {
  "Wansmer/treesj",
  keys = {
    { "<leader>ctt", "<cmd>TSJToggle<cr>", desc = "Toggle node under cursor" },
    { "<leader>ctj", "<cmd>TSJSplit<cr>", desc = "Split node under cursor" },
    { "<leader>cts", "<cmd>TSJJoin<cr>", desc = "Join node under cursor" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  config = function()
    require("treesj").setup({--[[ your config ]]
    })
  end,
}
