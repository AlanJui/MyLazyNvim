return {
  --  +------------------------------------------------------------------------------+
  --  |                              Basic enhencement                               |
  --  +------------------------------------------------------------------------------+
  { "rizzatti/dash.vim", event = "VeryLazy" },

  -- Switch between single-line and multiline forms of code: gS to split a one-liner into multiple lines. gJ (with the cursor on the first line of a block) to join a block into a single-line.
  { "AndrewRadev/splitjoin.vim", event = "VeryLazy" },

  -- switch segments of text with predefined replacements. default mapping `gs` to trigger the command
  {
    "AndrewRadev/switch.vim",
    keys = {
      { "gt", "<cmd>Switch<cr>", desc = "Switch" },
    },
  },
  -- tabbing out from parentheses, quotes, and similar contexts
  {
    "abecodes/tabout.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },
  -- surround
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup()
    end
  },
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
  -- better text-objects
  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- no need to load the plugin, since we only need its queries
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end,
      },
    },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      local ai = require("mini.ai")
      ai.setup(opts)
    end,
  },
  --  +------------------------------------------------------------------------------+
  --  |                                   Comments                                   |
  --  +------------------------------------------------------------------------------+
  { "LudoPinelli/comment-box.nvim", event = "VeryLazy" },
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment", },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>fT", "<cmd>TodoTelescope<cr>", desc = "Find Todo" },
    },
  },
  --  +------------------------------------------------------------------------------+
  --  |                                 Programming                                  |
  --  +------------------------------------------------------------------------------+
  -- A code outline window for skimming and quick navigation
  {
    "stevearc/aerial.nvim",
    config = true,
  },
  -- references
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
          pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
        end,
      })
    end,
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference", },
    },
  },
  -- refactoring library based off the Refactoring book by Martin Fowler
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension "refactoring"
    end,
    keys = function ()
      vim.api.nvim_set_keymap(
        "v",
        "<leader>rr",
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        { noremap = true, silent = true }
      )
    end
  },
  -- navigate between files that are related using regexp pattern
  {
    "otavioschwanck/telescope-alternate" ,
    config = function()
      require('telescope-alternate').setup({
        presets = { 'rails', 'rspec', },
        mappings = {
          -- jihulab rails
          { 'jh/app/models/(.*).rb', {
            { 'jh/app/controllers/**/*[1:pluralize]_controller.rb', 'JH Controller' },
            { 'jh/app/views/[1:pluralize]/*.html.haml', 'JH View' },
            { 'jh/app/helpers/[1]_helper.rb', 'JH Helper' },
          } },
          { 'jh/app/controllers(.*)/(.*)_controller.rb', {
            { 'jh/app/models/**/*[2:singularize].rb', 'JH Model' },
            { 'jh/app/views/[1][2]/*.html.haml', 'JH View' },
            { 'jh/app/helpers/**/*[2]_helper.rb', 'JH Helper' },
          } },
          -- jihulab rspec
          { 'jh/app/(.*).rb', { { 'jh/spec/[1]_spec.rb', 'JH Test' } } },
          { 'jh/spec/(.*)_spec.rb', { { 'jh/app/[1].rb', 'JH Original', true } } },
          { 'jh/app/controllers/(.*)_controller.rb', { { 'jh/spec/requests/[1]_spec.rb', 'JH Request Test' } } },
          { 'jh/spec/requests/(.*)_spec.rb', { { 'jh/app/controllers/[1]_controller.rb', 'JH Original Controller', true } } },
        },
      })
      require('telescope').load_extension('telescope-alternate')
    end,
  },
}
