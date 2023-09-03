return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- Automatically format on save
      autoformat = true,
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = false,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        jsonls = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeys[]
          -- keys = {},
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "hs" },
                disable = {
                  "lowercase-global",
                  "unused-local",
                  "missing-fields",
                  "undefined-doc-name",
                  "undefined-field",
                },
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        pyright = require("plugins.LSP.configs.pyright"),
        tsserver = require("plugins.LSP.configs.tsserver"),
        yamlls = require("plugins.LSP.configs.yamlls"),
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
  {
    "folke/neoconf.nvim",
    opts = {},
  },
  {
    "folke/neodev.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = nil,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    opts = nil,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- formatting
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.pylint, -- Python
          nls.builtins.diagnostics.mypy.with({
            extra_args = { "--config-file", "mypy.ini" },
          }),
          nls.builtins.diagnostics.pydocstyle.with({ extra_args = { "--config=$ROOT/setup.cfg" } }),
          nls.builtins.formatting.autopep8,
          nls.builtins.formatting.black,
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
      }
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "stylua",
        -- Shell Script
        "shellcheck",
        "shfmt",
        -- Python
        "pyright",
        "pylint",
        "debugpy", -- DAP
        "isort",
        "mypy",
        "pydocstyle",
        "flake8",
        "djlint",
        "autopep8",
        "black",
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
