require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticSeverityOverrides = {
          reportPrivateImportUsage = "none",
          reportAttributeAccessIssue = "none",
        },
      },
    },
  },
})

vim.lsp.config("zls", {
  cmd = { vim.fn.exepath "zls" },
  settings = {
    zls = {
      zig_exe_path = vim.fn.exepath "zig",
      enable_build_on_save = true,
      build_on_save_args = { "check" },
    },
  },
})

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "pyright",
  "rust_analyzer",
  "zls",
  "marksman",
  "texlab",
  "clangd",
}

vim.lsp.enable(servers)
