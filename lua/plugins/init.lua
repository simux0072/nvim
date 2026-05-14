return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- LSP Setup
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Package Manager (Mason)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "ts_ls",
        "eslint-lsp", -- JS/TS
        "pyright",
        "black",
        "isort",
        "ruff",
        "debugpy", -- Python
        "rust-analyzer", -- Rust
        "zls", -- Zig
        "codelldb",
        "marksman", -- Markdown
        "texlab", -- LaTeX
        "clangd",
        "clang-format", -- C/C++
      },
    },
  },

  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "c",
        "cpp",
        "rust",
        "zig",
        "markdown",
        "markdown_inline",
        "latex",
      },
    },
  },

  -- Linters
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- Debugging (DAP)
  {
    "mfussenegger/nvim-dap",
    ft = { "python", "c", "cpp", "rust", "zig" },
    config = function()
      local dap = require "dap"

      -- 1. Setup the codelldb adapter
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- Tell DAP where to find codelldb from Mason
          command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- 2. Create the Zig debugging configuration
      dap.configurations.zig = {
        {
          name = "Build & Launch Zig executable",
          type = "codelldb",
          request = "launch",
          program = function()
            -- 1. Run 'zig build' in the background
            vim.notify("Compiling Zig project...", vim.log.levels.INFO)
            local build_output = vim.fn.system "zig build"

            -- 2. Check if the build failed
            if vim.v.shell_error ~= 0 then
              vim.notify("Zig Build Failed:\n" .. build_output, vim.log.levels.ERROR)
              return nil -- Halts the debugger
            end

            vim.notify("Build successful!", vim.log.levels.INFO)

            -- 3. Proceed to prompt for the executable path
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      -- Automatically use the debugpy installation from Mason
      local path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },

  -- 1. Surround (Fast quoting and brackets)
  -- Usage: type `ysiw"` to surround a word in quotes, or `cs"'` to change quotes to single quotes.
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- 2. Trouble (Project-wide error panel)
  -- Usage: press `<space>xx` to see all errors.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
  },

  -- 3. Aerial (Code structure outline)
  -- Usage: press `<space>a` to see a table of contents of your functions/classes.
  {
    "stevearc/aerial.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      layout = { max_width = { 40, 0.2 }, min_width = 20 },
    },
  },

  -- 4. LazyGit Integration
  -- Usage: press `<space>gg` to open the visual git terminal.
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
