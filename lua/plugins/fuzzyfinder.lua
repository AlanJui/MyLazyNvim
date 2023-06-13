local Util = require("util")

return {
  -- telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { 'nvim-telescope/telescope-frecency.nvim', },
      { 'nvim-telescope/telescope-smart-history.nvim', },
      { 'nvim-telescope/telescope-live-grep-args.nvim', },
      { "aaronhallaert/advanced-git-search.nvim" },
      { "tsakirist/telescope-lazy.nvim" },
      { "crispgm/telescope-heading.nvim" },
      {  'kkharji/sqlite.lua'  },
      {
        "rmagatti/auto-session", -- Auto Session takes advantage of Neovim's existing session management capabilities to provide seamless automatic session management
        dependencies = { "rmagatti/session-lens" },
        config = function()
          require("session-lens").setup({})
          require("auto-session").setup({
            auto_session_root_dir = vim.fn.stdpath("config") .. "/sessions/",
            auto_session_enabled = false,
            auto_session_use_git_branch = true,
          })
        end,
      },
    },
    keys = {
      -- search
      { "<C-p>", Util.telescope("files"), desc = "Find Files" },
      { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "Browser" },
      { "<leader>fo", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "Browser on current buffer" },
      { "<leader>fc", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      {
        "<leader>cs",
        Util.telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol",
              { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      -- buffers
      {
        "<leader>/",
        function()
          require("lazyvim.util").telescope("live_grep")
        end,
        desc = "Grep (root dir)",
      },
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>bf", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Buffers" },
      -- code
      { "<leader>cD", "<cmd>Telescope dap configurations<cr>", desc = "DAP Config Picker" },
      { "<leader>co", "<cmd>Telescope aerial<cr>", desc = "Code Outline" },
      {
        "<leader>cS",
        function()
          require("lazyvim.util").telescope("lsp_workspace_symbols", {
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
      -- find
      {
        "<leader><space>",
        function()
          require("telescope.builtin").find_files({
            theme = "dropdown",
          })
        end,
        desc = "Find Files",
      },
      { "<leader>ff", require("util").find_files, desc = "Find Files" },
      { "<leader>fo", "<cmd>Telescope frecency theme=dropdown previewer=false<cr>", desc = "Recent" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      -- {
      --   "<leader>ff",
      --   "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>",
      --   desc = "Find Files (root dir)",
      -- },
      -- {
      --   "<leader>fF",
      --   function()
      --     -- require("telescope.builtin").find_files({ cmd = false })
      --     require("telescope.builtin").find_files({
      --       cwd = false,
      --       previewer = true,
      --       -- layout_strategy = "vertical",
      --       -- layout_config = {
      --       --   width = 0.8,
      --       -- },
      --     })
      --   end,
      --   desc = "Find Files (cwd)",
      -- },
      { "<leader>fB", "<cmd>Telescope file_browser<cr>", desc = "Browser" },
      { "<leader>fr", "<cmd>Telescope frecency theme=dropdown previewer=false<cr>", desc = "Frecency Files" },
      { "<leader>fR", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      -- git
      { "<leader>gr", "<cmd>Telescope repo list<cr>", desc = "List Git Repo" },
      { "<leader>gC", "<cmd>Telescope conventional_commits<cr>", desc = "Conventional Commits" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
      -- search
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current Buffer Fuzzy Find" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      {
        "<leader>sg",
        function()
          -- require("telescope.builtin").live_grep()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep (root dir)",
      },
      {
        "<leader>sG",
        function()
          -- require("telescope.builtin").live_grep({ cwd = false })
          require("telescope").extensions.live_grep_args.live_grep_args({ cwd = false })
        end,
        desc = "Grep (cwd)",
      },
      { "<leader>ss", "<cmd>Telescope luasnip<cr>", desc = "Snippets" },
      -- { "<leader>sw", "<cmd>Telescope live_grep<cr>", desc = "Workspace" },
      {
        "<leader>sw",
        function()
          require("telescope.builtin").telescope("grep_string")
        end,
        desc = "Word (root dir)",
      },
      {
        "<leader>sW",
        function()
          require("telescope.builtin").telescope("grep_string", { cwd = false })
        end,
        desc = "Word (cwd)",
      },
      -- trouble
      { "<leader>xx", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>xX", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      -- utility
      {
        "<leader>up",
        function()
          require("telescope").extensions.project.project({ display_type = "minimal" })
        end,
        desc = "List",
      },
      -- System
      { "<leader>zh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Help" },
      { "<leader>zc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>zC", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>zk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>zo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>zp", "<cmd>Telescope lazy<cr>", desc = "Plugins" },
      { "<leader>zP", "<cmd>lua require'telescope.builtin'.planets{}<cr>", desc = "Pickers" },
      { "<leader>zs", "<cmd>Telescope luasnip<cr>", desc = "Snippets" },
      {
        "<leader>zS",
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Colorscheme with preview",
      },

      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")
      local lga_actions = require('telescope-live-grep-args.actions')
      local enter_normal_mode = function()
        local mode = vim.api.nvim_get_mode().mode
        if mode == "i" then
          vim.cmd [[stopinsert]]
          return
        end
      end

      local opts = {
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
          },
          dynamic_preview_title = true,
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { 'truncate' },
          file_ignore_patterns = {"node_modules", "vendor/bundle", "%.jpg", "%.png"},
          history = {
            path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
          },
          mappings = {
            i = {
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["jj"] = actions.close,
              ["jk"] = enter_normal_mode,
              ["?"] = actions_layout.toggle_preview,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-g>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<c-h>"] = actions.which_key,
              ["<c-t>"] = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
              end,
            },
            n = {
              ["q"] = actions.close,
            }
          },
        },
        extensions = {
          fzf = {
            case_mode = "smart_case",
            fuzzy = true,
            override_file_sorter = true,
            override_generic_sorter = true,
          },
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
          },
          frecency = {
            default_workspace = 'CWD',
            show_unindexed = false,
            ignore_patterns = { '*.git/*', '*node_modules/*', '*vendor/*' },
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-e>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t" }),
                ["<C-h>"] = lga_actions.quote_prompt({ postfix = " -truby lib app ee jh -g '!spec/'" }),
              },
            },
          },
          advanced_git_search = {
            diff_plugin = "fugitive",
            show_builtin_git_pickers = false,
            git_flags = {},
            git_diff_flags = {},
          }
        },
      }
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("frecency")
      telescope.load_extension("smart_history")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("advanced_git_search")
      telescope.load_extension("lazy")
      telescope.load_extension("heading")
      telescope.load_extension("session-lens")
      telescope.load_extension("aerial")

      vim.api.nvim_create_user_command(
        "DiffCommitLine",
        "lua require('telescope').extensions.advanced_git_search.diff_commit_line()",
        { range = true }
      )
      vim.api.nvim_set_keymap( "v", "<leader>gl", ":DiffCommitLine<CR>", { noremap = true })
    end,
  },
}
