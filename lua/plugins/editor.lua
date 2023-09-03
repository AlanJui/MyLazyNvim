return {
  --  +------------------------------------------------------------------------------+
  --  |                              Basic enhencement                               |
  --  +------------------------------------------------------------------------------+
  -- Range, pattern and substitute preview tool
  "xtal8/traces.vim",
  -- Better quickfix window in Neovim
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  -- search/replace in multiple files
  { "nvim-pack/nvim-spectre" },

  -- A better user experience for viewing and interacting with Vim marks
  {
    "chentoast/marks.nvim",
    event = "BufReadPre",
    config = true,
  },
  -- new generation multiple cursors plugin,
  -- select words with Ctrl-N (like Ctrl-d in Sublime Text/VS Code)
  -- create cursors vertically with Ctrl-Down/Ctrl-Up
  -- select one character at a time with Shift-Arrows
  -- press n/N to get next/previous occurrence
  -- press [/] to select next/previous cursor
  -- press q to skip current and get next occurrence
  -- press Q to remove current cursor/selection
  { "mg979/vim-visual-multi", event = "BufReadPre" },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  --  +------------------------------------------------------------------------------+
  --  |                                   Windows                                    |
  --  +------------------------------------------------------------------------------+
  -- Easily jump between NeoVim windows
  {
    "https://gitlab.com/yorickpeterse/nvim-window.git",
    config = function()
      vim.cmd([[hi BlackOnLightYellow guifg=#000000 guibg=#f2de91]])
      require("nvim-window").setup({
        chars = { "a", "s", "f", "g", "h", "j", "k", "l" },
        normal_hl = "BlackOnLightYellow",
        hint_hl = "Bold",
        border = "none",
      })
    end,
  },
  -- Auto-Focusing and Auto-Resizing Splits/Windows
  -- {
  --   "beauwilliams/focus.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("focus").setup({
  --       autoresize = true,
  --       signcolumn = false,
  --       number = false,
  --       compatible_filetrees = { "nvimtree", "neo-tree" },
  --     })
  --   end,
  -- },
  --  +------------------------------------------------------------------------------+
  --  |                                    Extras                                    |
  --  +------------------------------------------------------------------------------+
  -- viewing all the URLs in a buffer
  {
    "axieax/urlview.nvim",
    event = "VeryLazy",
    config = function()
      require("urlview").setup({
        default_picker = "telescope",
      })
    end,
  },
  -- align text by split chars, defaut hotkey: ga/gA
  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.align").setup(opts)
    end,
  },
}
