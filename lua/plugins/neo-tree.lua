-- file explorer
return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    -- {
    --   "<leader>e",
    --   function()
    --     require("neo-tree.command").execute({ toggle = true, dir = require("util").get_root() })
    --   end,
    --   desc = "Explorer NeoTree (root dir)",
    -- },
    -- {
    --   "<C-u>",
    --   function()
    --     require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
    --   end,
    --   desc = "Explorer NeoTree (cwd)",
    -- },
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
      end,
      desc = "Explorer NeoTree (root dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = {
    close_if_last_window = true,
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every
      },
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          "node_modules",
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          ".yabs",
          ".gitignored",
          ".github",
          ".vscode",
          ".stylua.toml",
          ".venv",
          ".prettierrc.json",
          ".stylelintrc.json",
          ".djlint_rules.yaml",
          ".markdownlint.jsonc",
          ".vuepress",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          "thumbs.db",
          ".git",
          ".ipynb_checkpoints",
          ".venv",
          ".mypy_cache",
          ".pytest_cache",
          "node_modules",
          "package-lock.json",
          "poetry.lock",
          "yarn.locsk",
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    },
    commands = {
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then
            state.commands.toggle_node(state)
          else -- if expanded and has children, select the next child
            require("neo-tree.ui.render").focus_node(state, node:get_child_ids()[1])
          end
        else -- if not a directory just open it
          state.commands.open(state)
        end
      end,
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
    },
    window = {
      mappings = {
        ["<space>"] = "none",
        ["/"] = "noop",
        ["h"] = "parent_or_close",
        ["l"] = "child_or_open",
        ["o"] = "open",
        ["e"] = function()
          vim.api.nvim_exec("Neotree focus filesystem left", true)
        end,
        ["B"] = function()
          vim.api.nvim_exec("Neotree focus buffers left", true)
        end,
        -- ["g"] = function() vim.api.nvim_exec("Neotree focus git_status left",true) end,
        ["Y"] = function(state)
          local node = state.tree:get_node()
          -- relative
          local content = node.path:gsub(state.path, ""):sub(2)
          vim.fn.setreg('"', content)
          vim.fn.setreg("*", content)
        end,
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(_)
          require("neo-tree").close_all()
        end,
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
    },
  },
}
