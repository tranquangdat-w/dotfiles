-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.winbar = "%t %m"
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

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
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
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
	vim.fn.setreg("+", filepath) -- Copy to Neovim clipboard
	vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Copy to macOS clipboard
	print("Copied: " .. filepath)
end, { desc = "Copy absolute path to clipboard" })

vim.keymap.set("x", "p", "\"_dP", { desc = "Paste without overwriting clipboard" })

-- quickfix
vim.keymap.set("n", "<M-k>", ":cprev<CR>", { noremap = true, silent = true, desc = "Previous quickfix item" })
vim.keymap.set("n", "<M-j>", ":cnext<CR>", { noremap = true, silent = true, desc = "Next quickfix item" })

-- DBUIToggle
vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = false, silent = true, desc = "Toggle database UI" })

-- Tabs
vim.api.nvim_set_keymap('n', 'H', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true, desc = "Previous buffer" })
vim.api.nvim_set_keymap('n', 'L', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = "Next buffer" })

vim.api.nvim_set_keymap('n', '<leader>1', ':BufferGoto 1<CR>', { noremap = true, silent = true, desc = "Go to buffer 1" })
vim.api.nvim_set_keymap('n', '<leader>2', ':BufferGoto 2<CR>', { noremap = true, silent = true, desc = "Go to buffer 2" })
vim.api.nvim_set_keymap('n', '<leader>3', ':BufferGoto 3<CR>', { noremap = true, silent = true, desc = "Go to buffer 3" })
vim.api.nvim_set_keymap('n', '<leader>4', ':BufferGoto 4<CR>', { noremap = true, silent = true, desc = "Go to buffer 4" })
vim.api.nvim_set_keymap('n', '<leader>5', ':BufferGoto 5<CR>', { noremap = true, silent = true, desc = "Go to buffer 5" })
vim.api.nvim_set_keymap('n', '<leader>6', ':BufferGoto 6<CR>', { noremap = true, silent = true, desc = "Go to buffer 6" })
vim.api.nvim_set_keymap('n', '<leader>7', ':BufferGoto 7<CR>', { noremap = true, silent = true, desc = "Go to buffer 7" })
vim.api.nvim_set_keymap('n', '<leader>8', ':BufferGoto 8<CR>', { noremap = true, silent = true, desc = "Go to buffer 8" })
vim.api.nvim_set_keymap('n', '<leader>9', ':BufferGoto 9<CR>', { noremap = true, silent = true, desc = "Go to buffer 9" })
vim.api.nvim_set_keymap('n', '<leader>0', ':BufferLast<CR>', { noremap = true, silent = true, desc = "Go to last buffer" })
vim.api.nvim_set_keymap('n', '<M-c>', ':BufferClose<CR>', { noremap = true, silent = true, desc = "Close buffer" })

vim.api.nvim_set_keymap('n', '<M-h>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true, desc = "Move buffer to left" })
vim.api.nvim_set_keymap('n', '<M-l>', '<Cmd>BufferMoveNext<CR>',{ noremap = true, silent = true, desc = "Move buffer to right" })

vim.keymap.set("n", "<leader>/", function()
  vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { desc = "Toggle hlsearch" })

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.java",
  callback = function()
    local file = vim.fn.expand("%:p")
    vim.fn.jobstart({ "google-java-format", "-i", file }, {
      on_exit = function()
        vim.cmd("edit!")  -- reload lại sau khi format
      end,
    })
  end,
  desc = "Auto format Java file on save using google-java-format",
})
