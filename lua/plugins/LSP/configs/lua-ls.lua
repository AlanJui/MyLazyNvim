return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "hs", "astronvim" },
        disable = {
          "lowercase-global",
          "unused-local",
          "missing-fields",
          "undefined-doc-name",
          "assign-type-mismatch",
        },
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
