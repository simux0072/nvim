require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "ei", "<ESC>")

map("n", "<C-u>", "<C-u>zz", { desc = "Move up half a page and center the cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Move down half a page and center the cursor" })

-- Ctrl-a is the tmux prefix, so keep number increment/decrement easy to reach.
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Smart Splits keeps these keys inside Neovim until the cursor reaches an
-- outer edge, then hands movement to tmux. Alt+arrows resize either kind.
local has_smart_splits, smart_splits = pcall(require, "smart-splits")
if has_smart_splits then
  map("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to left split/pane" })
  map("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to lower split/pane" })
  map("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to upper split/pane" })
  map("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to right split/pane" })
  map("n", "<A-Left>", smart_splits.resize_left, { desc = "Resize split/pane left" })
  map("n", "<A-Down>", smart_splits.resize_down, { desc = "Resize split/pane down" })
  map("n", "<A-Up>", smart_splits.resize_up, { desc = "Resize split/pane up" })
  map("n", "<A-Right>", smart_splits.resize_right, { desc = "Resize split/pane right" })
end

-- DAP Debugging Keymaps
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle Debug UI" })
map("n", "<leader>ds", function()
  require("dap").step_over()
end, { desc = "Step over (Next line)" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step into (Enter function)" })
map("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "Step out (Exit function)" })
map("n", "<leader>dq", function()
  require("dap").terminate()
end, { desc = "Quit / Terminate debugger" })

-- Power-User Plugin Keymaps
map("n", "<leader>xx", "<cmd> Trouble diagnostics toggle <CR>", { desc = "Toggle Trouble Error Panel" })
map("n", "<leader>gg", "<cmd> LazyGit <CR>", { desc = "Open LazyGit" })
map("n", "<leader>a", "<cmd> AerialToggle! right<CR>", { desc = "Toggle Aerial Code Outline" })

map("n", "<leader>e", vim.diagnostic.open_float, {
  desc = "Show diagnostic under cursor",
})

map("n", "[d", vim.diagnostic.goto_prev, {
  desc = "Previous diagnostic",
})

map("n", "]d", vim.diagnostic.goto_next, {
  desc = "Next diagnostic",
})
