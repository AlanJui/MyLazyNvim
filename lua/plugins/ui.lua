return {
  --  +------------------------------------------------------------------------------+
  --  |                              Basic enhencement                               |
  --  +------------------------------------------------------------------------------+
  {
    "j-hui/fidget.nvim",
    disabled = true,
  },
  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "rcarriga/nvim-notify",
    -- enableed = false,
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("lazyvim.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  {
    "stevearc/dressing.nvim",
    -- enableed = false,
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    config = function()
      require("dressing").setup({
        input = {
          override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
          end,
        },
      })
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- which key integration
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          if require("lazyvim.util").has("noice.nvim") then
            opts.defaults["<leader>sn"] = { name = "+noice" }
          end
        end,
      },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>xnl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>xnh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>xna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>xnd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  -- {
  --   "SmiteshP/nvim-navic",
  --   lazy = true,
  --   init = function()
  --     vim.g.navic_silence = true
  --     require("lazyvim.util").on_attach(function(client, buffer)
  --       if client.server_capabilities.documentSymbolProvider then
  --         require("nvim-navic").attach(client, buffer)
  --       end
  --     end)
  --   end,
  --   opts = function()
  --     return {
  --       separator = " ",
  --       highlight = true,
  --       depth_limit = 5,
  --       icons = require("lazyvim.config").icons.kinds,
  --     }
  --   end,
  -- },

  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        -- custom LazyVim option to enable the tailwind integration
        tailwind = {
          enabled = true,
          ft = { "typescriptreact", "javascriptreact", "css", "javascript", "typescript", "html" },
          -- full: the whole css class will be highlighted
          -- compact: only the color will be highlighted
          style = "full",
        },
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
        },
      }
    end,
    config = function(_, opts)
      -- backward compatibility
      if opts.tailwind == true then
        opts.tailwind = {
          enabled = true,
          ft = { "typescriptreact", "javascriptreact", "css", "javascript", "typescript", "html" },
          style = "full",
        }
      end
      if type(opts.tailwind) == "table" and opts.tailwind.enabled then
        -- reset hl groups when colorscheme changes
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            M.hl = {}
          end,
        })
        opts.highlighters.tailwind = {
          pattern = function()
            if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
              return
            end
            if opts.tailwind.style == "full" then
              return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
            elseif opts.tailwind.style == "compact" then
              return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
            end
          end,
          group = function(_, _, m)
            ---@type string
            local match = m.full_match
            ---@type string, number
            local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
            shade = assert(tonumber(shade))
            local bg = vim.tbl_get(M.colors, color, shade)
            if bg then
              local hl = "MiniHipatternsTailwind" .. color .. shade
              if not M.hl[hl] then
                M.hl[hl] = true
                local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
                local fg = vim.tbl_get(M.colors, color, bg_shade)
                vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
              end
              return hl
            end
          end,
          priority = 2000,
        }
      end
      require("mini.hipatterns").setup(opts)
    end,
  },

  --  +------------------------------------------------------------------------------+
  --  |                                  Dashboard                                   |
  --  +------------------------------------------------------------------------------+
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = require("utils.logo")["random"]
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "󰈙" .. " Recent files", ":Telescope frecency <CR>"),
        dashboard.button("g", " " .. " Grep text", ":Telescope live_grep <CR>"),
        dashboard.button("u", "" .. " Update plugins", ":Lazy update<CR>"),
        dashboard.button("c", " " .. " Config NeoVim", ":e $MYVIMRC <CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      vim.b.miniindentscope_disable = true

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          local version = " v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          local footer = "\t" .. version .. "\t" .. plugins
          dashboard.section.footer.val = footer
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
