local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    rust = { "rustfmt" },
    zig = { "zigfmt" }, -- zigfmt is native to the zig compiler
    c = { "clang-format" },
    cpp = { "clang-format" },
    tex = { "latexindent" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
