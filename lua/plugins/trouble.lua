-- Tool for dsiplaying diagnostics, references, telescope results, quickfix and loclist items
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Diagnostics Window" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Toggle Diagnostics in Workspace" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Toggle Diagnostics in File" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Toggle Location List" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Toggle Quick Fix" },
    { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "Toggle LSP References" },
  },
}
