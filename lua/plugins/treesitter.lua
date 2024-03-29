return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "cmake",
      "css",
      "dockerfile",
      "go",
      "gomod",
      "html",
      "http",
      "markdown",
      "markdown_inline",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "regex",
      "ruby",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",

      "vue",
      "yaml",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
}
