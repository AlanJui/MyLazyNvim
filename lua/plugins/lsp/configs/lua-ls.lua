return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "hs" },
      },
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   [vim.fn.stdpath("config") .. "/lua"] = true,
        --   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        -- },
      },
      completion = {
        callSnippet = "Replace",
      },
      -- telemetry = { enable = false },
      -- hint = {
      --   enable = false,
      -- },
    },
  },
}
