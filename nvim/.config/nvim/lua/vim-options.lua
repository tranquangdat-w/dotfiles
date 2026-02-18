-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- vim.opt.colorcolumn = "94"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim.opt.winbar = "      %t %m"
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.swapfile = false

vim.opt.guicursor = "n-v-c-i:block"

-- To copy in clipboard in vim
-- vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- Set Esc to switch to normal mode in terminal
-- vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab",
})

vim.o.background = "dark" -- or "light" for light mode

-- UFO folding
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.keymap.set("n", "<C-w>h", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<C-w>v", "<C-w>s", { desc = "Split window horizontally" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, {
    border = "rounded",
  })
end, { desc = "Show diagnostics (with border)" })

-- copy current file path (absolute) into clipboard
vim.keymap.set("n", "<leader>cp", function()
  local filepath = vim.fn.expand("%:p")
  vim.fn.setreg("+", filepath)                        -- Copy to Neovim clipboard
  vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Copy to macOS clipboard
  print("Copied: " .. filepath)
end, { desc = "Copy absolute path to clipboard" })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without overwriting clipboard" })

-- quickfix
vim.keymap.set("n", "<leader>cc", function()
  local qf_open = false
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_open = true
      break
    end
  end

  if qf_open then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { noremap = true, silent = true, desc = "Toggle quickfix" })

-- change size panel
vim.keymap.set("n", "<A-h>", "3<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-l>", "3<C-w>>", { desc = "Increase window width" })

-- DBUIToggle
vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = false, silent = true, desc = "Toggle database UI" })

-- Diagnostic state (global để dễ dùng ở nơi khác, ví dụ lualine)
vim.g.minimal_diagnostic = false

-- Default config
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  underline = true,
  signs = true,
})

-- Toggle keymap
vim.keymap.set("n", "<leader>id", function()
  vim.g.minimal_diagnostic = not vim.g.minimal_diagnostic

  vim.diagnostic.config({
    virtual_text = not vim.g.minimal_diagnostic,
    virtual_lines = false,
    underline = not vim.g.minimal_diagnostic,
    signs = not vim.g.minimal_diagnostic,
  })

  local msg = vim.g.minimal_diagnostic
    and "Minimal diagnostics (only signs)"
    or "Full diagnostics"

  print(msg)
end, { desc = "Toggle minimal diagnostics" })

-- Open image file
vim.keymap.set("n", "<leader>si", ":!feh %<CR>", { desc = "Open image file" })

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "highlight select on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 40, visual = true })
  end
})
