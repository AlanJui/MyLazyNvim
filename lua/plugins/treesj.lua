return {
  "Wansmer/treesj",
  keys = {
    { "<leader>tj", "<cmd>TSJToggle<cr>", desc = "Toggle node under cursor" },
    { "<leader>cjs", "<cmd>TSJSplit<cr>", desc = "Split node under cursor" },
    { "<leader>cjj", "<cmd>TSJJoin<cr>", desc = "Join node under cursor" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  config = function()
    require("treesj").setup({--[[ your config ]]
    })
  end,
}
