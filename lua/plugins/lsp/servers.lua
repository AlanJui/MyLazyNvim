local M = {}

local lsp_utils = require("plugins.lsp.utils")
local icons = require("config.icons")

local function lsp_init()
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- LSP handlers configuration
  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },

    diagnostic = {
      -- virtual_text = false,
      -- virtual_text = { spacing = 4, prefix = "●" },
      virtual_text = {
        severity = {
          min = vim.diagnostic.severity.ERROR,
        },
      },
      signs = {
        active = signs,
      },
      underline = false,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      -- virtual_lines = true,
    },
  }

  -- Diagnostic configuration
  vim.diagnostic.config(config.diagnostic)

  -- Hover configuration
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

  -- Signature help configuration
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

function M.setup(_, opts)
  -- 自 lsp_utils 模組，取用 on_attach function , 進行 LSP Client 的 on_attach 設定
  lsp_utils.on_attach(function(client, buffer)
    require("plugins.lsp.format").on_attach(client, buffer)
    require("plugins.lsp.keymaps").on_attach(client, buffer)
  end)

  lsp_init() -- diagnostics, handlers

  -- 取出全部需設定之 LSP servers configuration
  local servers = opts.servers
  require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      -- 取出單一 LSP server configuration
      local server_opts = servers[server_name] or {}
      -- 設定 LSP server capabilities
      server_opts.capabilities = lsp_utils.capabilities()
      ------------------------------------------------------------
      -- 若 LSP Server 有設定 setup function, 則依 function 執行設定作業；
      -- 否則使用 lspconfig 內建之 setup function
      ------------------------------------------------------------
      -- 若此 server_name 存在特定的 setup function ，
      if opts.setup[server_name] then
        -- 則依其 setup function 執行設定作業；其設定結果若成功，則結束此 function
        if opts.setup[server_name](server_name, server_opts) then
          return
        end
      -- 若此 server_name 不存在特定的 setup function ，
      elseif opts.setup["*"] then
        -- 則依 mason-lspconfig 內建之 setup function 執行設定作業；
        -- 其設定結果若成功，則結束此 function
        if opts.setup["*"](server_name, server_opts) then
          return
        end
      end
      -- 若此 server_name 不存在特定的 setup function ；或
      -- 其設定結果若失敗，則使用 lspconfig 內建之 setup function
      require("lspconfig")[server_name].setup(server_opts)
    end,
  })
end

return M
