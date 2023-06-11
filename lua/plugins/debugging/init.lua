return {
  --  +----------------------------------------------------------+
  --  |                          Debug                           |
  --  +----------------------------------------------------------+
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text" },
      {
        "rcarriga/nvim-dap-ui",
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      { "jay-babu/mason-nvim-dap.nvim" },
      { "LiadOz/nvim-dap-repl-highlights", opts = {} },
      { "nvim-telescope/telescope-dap.nvim" },
      { "leoluz/nvim-dap-go" },
      { "jbyuki/one-small-step-for-vimkind" },
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>dE",
        function() require("dapui").eval(vim.fn.input "[Expression] > ") end,
        desc = "Evaluate Input",
      },
      {
        "<leader>dS",
        function() require("dap.ui.widgets").scopes() end,
        desc = "Scopes",
      },
      {
        "<leader>dU",
        function() require("dapui").toggle() end,
        desc = "Toggle UI",
      },
      {
        "<leader>dC",
        function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end,
        desc = "Conditional Breakpoint",
      },
      { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
      { "<leader>db", function() require("dap").step_back() end, desc = "Step Back", },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
      { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect", },
      { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
      { "<leader>dg", function() require("dap").session() end, desc = "Get Session", },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
      { "<leader>du", function() require("dap").step_out() end, desc = "Step Out", },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
      { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
      { "<leader>dq", function() require("dap").close() end, desc = "Quit", },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
      { "<leader>ds", function() require("dap").continue() end, desc = "Start", },
      { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
      -- Lua adapter
      {
        "<leader>daL",
        function()
          require("osv").launch({ port = 8086 })
        end,
        desc = "Start Lua Language Server",
      },
      {
        "<leader>dal",
        function()
          require("osv").run_this()
        end,
        desc = "Start Lua Debugging",
      },
    },
    opts = {
      setup = {
        osv = function(_, _)
          require("plugins.debugging.lua").setup()
        end,
        python = function(_, _)
          require("plugins.debugging.python").setup()
        end,
        -- js = function(_, _)
        --   require("plugins.debugging.js").setup()
        -- end,
      },
    },
    config = function(plugin, opts)
      -- local icons = require "config.icons"
      -- vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      --
      -- for name, sign in pairs(icons.dap) do
      --   sign = type(sign) == "table" and sign or { sign }
      --   vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] })
      -- end
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })

      require("nvim-dap-virtual-text").setup {
        commented = true,
      }

      local dap= require "dap"

      require("dap.ext.vscode").load_launchjs()
      require("telescope").load_extension "dap"
      -- adapters
      require("dap-go").setup()

      -- set up debugger
      for k, _ in pairs(opts.setup) do
        opts.setup[k](plugin, opts)
      end

      -- require("plugins.debugging.lua").setup()
      -- require("plugins.debugging.python").setup()
      -- require("plugins.debugging.js").setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_setup = true,
      handlers = {},
      ensure_installed = {},
    },
  },
}
