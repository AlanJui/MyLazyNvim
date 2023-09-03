return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            plugins = { "neotest", "nvim-dap-ui" },
            types = true,
          },
        },
      },
      {
        "smjonas/inc-rename.nvim",
        config = function()
          require("inc_rename").setup({
            cmd_name = "IncRename", -- the name of the command
            hl_group = "Substitute", -- the highlight group used for highlighting the identifier's new name
            preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
            show_message = true, -- whether to display a `Renamed m instances in n files` message after a rename operation
            -- input_buffer_type = nil, -- the type of the external input buffer to use (the only supported value is currently "dressing")
            input_buffer_type = "dressing",
            post_hook = nil, -- callback to run after renaming, receives the result table (from LSP handler) as an argument
          })
        end,
      },
      "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazyvim.util").has("nvim-cmp")
        end,
      },
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    opts = {
      servers = {
        lua_ls = require("plugins.lsp.configs.lua-ls"),
        pyright = require("plugins.lsp.configs.pyright"),
        tsserver = require("plugins.lsp.configs.tsserver"),
        yamlls = require("plugins.lsp.configs.yamlls"),
        -- dockerls = {},
        -- bashls = {},
        -- cssls = {},
        -- html = {},
        -- marksman = {},
        -- jsonls = {},
        -- ruby_ls = {},
        -- tailwindcss = {},
        -- vimls = {},
        -- vuels = {},
      },
      setup = {
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
        lua_ls = function(_, opts)
          local lsp_utils = require("plugins.lsp.utils")
          lsp_utils.on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "lua_ls" then
              vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end,
                { buffer = buffer, desc = "OSV Run" })
              vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end,
                { buffer = buffer, desc = "OSV Launch" })
            end
          end)
        end,
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.servers").setup(plugin, opts)
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = { border = "rounded" },
      ensure_installed = {
        -- Lua
        "stylua",
        -- Shell Script
        "shellcheck",
        "shfmt",
        -- Python
        "pylint",
        "debugpy", -- DAP
        "isort",
        "mypy",
        "pydocstyle",
        "flake8",
        "djlint",
        "autopep8",
        -- Web Tools
        "typescript-language-server",
        "js-debug-adapter",
        "prettier",
        "golangci-lint",
        "eslint_d", -- javascript
        -- Misc.
        "markdownlint", -- Markdown
        "jq", -- JSON
        "yamllint",
      },
    },
    config = function(_, opts)
      require("mason").setup()
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- formatters / linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        border = "rounded",
        sources = {
          -- formatting
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.pylint, -- Python
          nls.builtins.diagnostics.mypy.with({
            extra_args = { "--config-file", "mypy.ini" },
          }),
          nls.builtins.diagnostics.pydocstyle.with({ extra_args = { "--config=$ROOT/setup.cfg" } }),
          nls.builtins.formatting.autopep8,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.djhtml,
          nls.builtins.formatting.markdown_toc, -- Markdown
          nls.builtins.formatting.markdownlint,
          nls.builtins.diagnostics.eslint_d, -- Web Tools
          nls.builtins.diagnostics.stylelint,
          nls.builtins.formatting.prettierd,
          -- nls.builtins.formatting.prettier.with({
          --   extra_args = { "--single-quote", "false" },
          --   filetypes = {
          --     "html",
          --     "css",
          --     "scss",
          --     "less",
          --     "javascript",
          --     "typescript",
          --     "vue",
          --     "json",
          --     "jsonc",
          --     "yaml",
          --     "markdown",
          --     "handlebars",
          --   },
          --   extra_filetypes = {},
          -- }),
          nls.builtins.formatting.goimports,
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.jq,

          -- diagnostics
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.diagnostics.standardrb,
          nls.builtins.diagnostics.golangci_lint,
          nls.builtins.diagnostics.zsh,

          -- code actions
          nls.builtins.code_actions.eslint_d,
          nls.builtins.code_actions.gitrebase,
          nls.builtins.code_actions.gitsigns,
          nls.builtins.code_actions.refactoring,
          nls.builtins.code_actions.shellcheck,
        },
      })
    end,
  },

  -- VS Code like winbar that use nvim-navic in order to get LSP context from your language server
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },

  -- LSP enhancements for neovim
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      require("lspsaga").setup({})
    end,
  },
}
