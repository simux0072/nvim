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
      require("dap-python").setup "debugpy-adapter"
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

  -- Seamless navigation between Neovim windows and tmux panes.
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {
      at_edge = "stop",
      default_amount = 3,
    },
  },

  -- Project-aware Neovim sessions. Sessions are saved automatically after a
  -- real file is opened, but restored only when explicitly requested.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore project session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Do not save this session",
      },
    },
  },

  -- Label-based jumps within and across windows.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter search",
      },
      {
        "<C-s>",
        mode = "c",
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash search",
      },
    },
  },

  -- Test runner UI. The Python adapter supports pytest and unittest and can
  -- use a project's uv/.venv environment when one is present.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    opts = function()
      return {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
          },
        },
      }
    end,
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Test nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test file",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run { strategy = "dap" }
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open { enter = true }
        end,
        desc = "Open test output",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand "%")
        end,
        desc = "Watch test file",
      },
    },
  },
}
