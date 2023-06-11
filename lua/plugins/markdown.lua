return {
  -- preview markdown on your modern browser with synchronised scrolling
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
    keys = {
      { "<leader>um", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Previewer" },
    },
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
  },
  -- Markdown Syntax Highlighting
  -- URL: https://github.com/preservim/vim-markdown
  {
    "preservim/vim-markdown",
    config = function()
      -- 變更預設：文件內容毋需折疊
      vim.g.vim_markdown_folding_disabled = 1
      -- vim.g.markdown_fenced_languages = {
      --   "html",
      --   "python",
      --   "bash=sh",
      -- }
      -- disabling conceal for code fences
      -- vim.g.markdown_conceal_code_blocks = 0
    end,
  },
  -- Live server
  {
    "turbio/bracey.vim",
    run = "npm install --prefix server",
  },
  -- Open URI with your favorite browser from your most favorite editor
  { "tyru/open-browser.vim" },
  -- Preview markdown file
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    ft = { "markdown" },
    keys = {
      { "<leader>um", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Previewer" },
    },
    -- enabled = false,
    -- build = "cd app && npm install",
    -- opts = function()
    --   vim.g.mkdp_filetypes = { "markdown" }
    -- end,
  },
  -- PlantUML
  {
    "weirongxu/plantuml-previewer.vim",
    keys = {
      { "<leader>uP", "<cmd>PlantumlToggle<cr>", desc = "Toggle PUML Previewer" },
    },
    config = function()
      vim.g.puml_jar_path = vim.fn.stdpath("data") .. "/lazy/plantuml-previewer.vim/lib/plantuml.jar"
      vim.g.puml_previewer = vim.fn.stdpath("data") .. "/lazy/plantuml-previewer.vim/viewer/dist"
      vim.cmd([[
        autocmd FileType plantuml let g:plantuml_previewer#plantuml_jar_path = g:puml_jar_path
      ]])

      -- vim.g.puml_previewer_save_format = "png"
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "9999"
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_page_title = "${name}"
    end,
  },
  -- PlantUML syntax highlighting
  { "aklt/plantuml-syntax" },
  -- provides support to mermaid syntax files (e.g. *.mmd, *.mermaid)
  { "mracos/mermaid.vim" },
}
