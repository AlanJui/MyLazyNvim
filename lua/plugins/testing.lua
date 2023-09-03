return {
  --  +---------------------------------------------------------+
  --  |                         Testing                         |
  --  +---------------------------------------------------------+
  -- test running tool for many languages
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tc", "<cmd>TestClass<cr>", desc = "Class" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "File" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Last" },
      { "<leader>tt", "<cmd>TestNearest<cr>", desc = "Nearest" },
      { "<leader>ts", "<cmd>TestSuite<cr>", desc = "Suite" },
      { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Visit" },
    },
    config = function()
      vim.g["test#strategy"] = "neovim" -- 'basic' or 'neovim'
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1
      vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
      vim.g["test#go#gotest#executable"] = "go test -v"
    end,
  },
  -- a modern user interface to run or debug test cases
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>tnF",
        "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
        desc = "Debug File"
      },
      {
        "<leader>tnL",
        "<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<cr>",
        desc = "Debug Last"
      },
      {
        "<leader>tnN",
        "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
        desc = "Debug Nearest"
      },
      {
        "<leader>tna",
        "<cmd>lua require('neotest').run.attach()<cr>",
        desc = "Attach"
      },
      {
        "<leader>tnf",
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
        desc = "File"
      },
      {
        "<leader>tnl",
        "<cmd>lua require('neotest').run.run_last()<cr>",
        desc = "Last"
      },
      {
        "<leader>tnn",
        "<cmd>lua require('neotest').run.run()<cr>",
        desc = "Nearest"
      },
      {
        "<leader>tno",
        "<cmd>lua require('neotest').output.open({ enter = true })<cr>",
        desc = "Output"
      },
      {
        "<leader>tns",
        "<cmd>lua require('neotest').summary.toggle()<cr>",
        desc = "Summary"
      },
      {
        "<leader>tnt",
        "<cmd>lua require('neotest').run.stop()<cr>",
        desc = "Stop"
      },
    },
    dependencies = {
      "vim-test/vim-test",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-go",
      "olimorris/neotest-rspec",
    },
    config = function()
      local opts = {
        adapters = {
          require("neotest-go"),
          require("neotest-rspec"),
          require("neotest-plenary"),
          require("neotest-vim-test")({
            ignore_file_types = { "vim", "lua" },
          }),
        },
      }
      require("neotest").setup(opts)
    end,
  },
}
