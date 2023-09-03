return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        stubPath = vim.fn.stdpath("config") .. "/stubs",
      },
    },
  },
}
