return {
  -- preview markdown on your modern browser with synchronised scrolling
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
  },
}
