return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim",      cmd = "Neoconf", config = true },
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            plugins = { "neotest", "nvim-dap-ui" },
            types = true
          },
        },
      },
      { "j-hui/fidget.nvim",       config = true,   tag = "legacy" },
      { "smjonas/inc-rename.nvim", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("util").has("nvim-cmp")
        end,
      },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
      },
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = { enable = false },
              hint = {
                enable = false,
              },
            },
          },
        },
        dockerls = {},
        yamlls = {
          schemastore = {
            enable = true,
          },
          settings = {
            yaml = {
              hover = true,
              completion = true,
              validate = true,
            },
          },
        },
        bashls = {},
        cssls = {},
        html = {},
        marksman = {},
        jsonls = {},
        tsserver = {},
        ruby_ls = {},
        tailwindcss = {},
        vimls = {},
        vuels = {},
      },
      setup = {
        lua_ls = function(_, _)
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
          local lsp_utils = require "plugins.lsp.utils"
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
        "stylua",     -- Lua Script
        "shellcheck", -- Shell Script
        "shfmt",
        "pylint",     -- Python
        "isort",
        "mypy",
        "pydocstyle",
        "flake8",
        "djlint",
        "autopep8",
        "prettier",     -- Web Tools
        "golangci-lint",
        "markdownlint", -- Markdown
        "jq",           -- JSON
        "eslint_d",     -- javascript
        "yamllint",
        "debugpy",      -- DAP
        "js-debug-adapter",
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

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup {
        border = "rounded",
        sources = {
          -- formatting
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.pylint, -- Python
          nls.builtins.diagnostics.mypy.with({ extra_args = { "--config-file", "pyproject.toml" } }),
          nls.builtins.diagnostics.pydocstyle.with({ extra_args = { "--config=$ROOT/setup.cfg" } }),
          nls.builtins.formatting.autopep8,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.djhtml,
          nls.builtins.formatting.markdown_toc, -- Markdown
          nls.builtins.formatting.markdownlint,
          nls.builtins.diagnostics.eslint_d,    -- Web Tools
          nls.builtins.diagnostics.stylelint,
          nls.builtins.formatting.prettier.with({
            extra_args = { "--single-quote", "false" },
            filetypes = {
              "html",
              "css",
              "scss",
              "less",
              "javascript",
              "typescript",
              "vue",
              "json",
              "jsonc",
              "yaml",
              "markdown",
              "handlebars",
            },
            extra_filetypes = {},
          }),
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

  -- Tool for dsiplaying diagnostics, references, telescope results, quickfix and loclist items
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
      { "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    },
  },

  -- LSP enhancements for neovim
  {
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    config = true,
  },
}
