-- Tool for dsiplaying diagnostics, references, telescope results, quickfix and loclist items
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Diagnostics Window" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Toggle Location List" },
    { "<leader>xr", "<cmd>TroubleRefresh<cr>", desc = "Refresh Trouble List Winodw" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Toggle Quick Fix" },
    { "<leader>xR", "<cmd>TroubleToggle lsp_references<cr>", desc = "Toggle LSP References" },
    { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "Toggle LSP References" },
  },
}
