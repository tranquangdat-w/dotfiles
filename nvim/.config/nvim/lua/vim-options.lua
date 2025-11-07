-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.colorcolumn = "94"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.winbar = "      %t %m"
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
vim.cmd([[
  autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
]])


-- paste over highlight word
vim.keymap.set("x", "<leader>p", '"_dP')

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
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- copy current file path (absolute) into clipboard
vim.keymap.set("n", "<leader>cp", function()
  local filepath = vim.fn.expand("%:p")
  vim.fn.setreg("+", filepath)                        -- Copy to Neovim clipboard
  vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Copy to macOS clipboard
  print("Copied: " .. filepath)
end, { desc = "Copy absolute path to clipboard" })

vim.keymap.set("x", "p", "\"_dP", { desc = "Paste without overwriting clipboard" })

-- quickfix
vim.keymap.set("n", "<M-k>", ":cprev<CR>", { noremap = true, silent = true, desc = "Previous quickfix item" })
vim.keymap.set("n", "<M-j>", ":cnext<CR>", { noremap = true, silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cq", ":cclose<CR>", { noremap = true, silent = true, desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { noremap = true, silent = true, desc = "Open quickfix list" })

-- change size panel
vim.keymap.set("n", "<A-h>", "3<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-l>", "3<C-w>>", { desc = "Increase window width" })

-- DBUIToggle
vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = false, silent = true, desc = "Toggle database UI" })

-- Inline search
vim.keymap.set("n", "<leader>/", ":nohl<CR>", { desc = "Close hlsearch" })

-- Diagnostics toggle
local minimal_diagnostic = false
vim.keymap.set("n", "<leader>id", function()
  minimal_diagnostic = not inimal_diagnostic
  vim.diagnostic.config({
    virtual_text = not minimal_diagnostic,
    virtual_lines = false,
    underline = not minimal_diagnostic,
    signs = true,
  })
  print(minimal_diagnostic and "Minimal diagnostics (only signs)" or "Full diagnostics")
end, { desc = "Toggle minimal diagnostics" })

-- Open image file
vim.keymap.set("n", "<leader>si", ":!feh %<CR>", { desc = "Open image file" })
