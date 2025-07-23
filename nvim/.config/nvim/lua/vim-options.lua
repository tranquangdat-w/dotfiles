-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- To copy in clipboard in vim
-- vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- Set Esc to switch to normal mode in terminal
vim.cmd([[ 
  autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
]])

vim.o.background = "dark" -- or "light" for light mode

vim.cmd [[
  autocmd FileType * setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
]]

-- UFO folding
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.keymap.set("n", "<C-w>h", "<C-w>v")
vim.keymap.set("n", "<C-w>v", "<C-w>s")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- copy current file path (absolute) into clipboard
vim.keymap.set("n", "<leader>cp", function()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", filepath) -- Copy to Neovim clipboard
	vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Copy to macOS clipboard
	print("Copied: " .. filepath)
end, { desc = "Copy absolute path to clipboard" })

-- quickfix
vim.keymap.set("n", "<M-k>", ":cprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-j>", ":cnext<CR>", { noremap = true, silent = true })

-- DBUIToggle
vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = false, silent = true })

