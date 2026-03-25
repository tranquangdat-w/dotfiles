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
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
-- vim.opt.hlsearch = true
-- vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

vim.opt.swapfile = false

vim.opt.guicursor = "n-v-c-i:block"

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})

-- To copy in clipboard in vim
-- vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- Set Esc to switch to normal mode in terminal
-- vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab",
})

vim.o.background = "dark" -- or "light" for light mode

-- Folding
vim.o.foldenable = true
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.o.fillchars = "eob:~,foldopen:v,foldclose:>"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "]`", "]`zz")
vim.keymap.set("n", "[`", "[`zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { noremap = true, silent = true })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>zz", { noremap = true, silent = true })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
  vim.cmd("normal! zz")
end)

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1,  float = true })
  vim.cmd("normal! zz")
end)

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
  virtual_text = false,
  virtual_lines = false,
  underline = true,
  signs = true,
})

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

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({"n", "v"}, "<leader>dd", [["_d]])
vim.keymap.set("n", "j", function(...)
  local count = vim.v.count

  if count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })

vim.keymap.set("n", "k", function(...)
  local count = vim.v.count

  if count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

vim.keymap.set("n", "<left>", "gT")
vim.keymap.set("n", "<right>", "gt")

vim.keymap.set("c", "<CR>", function()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == "/" or cmdtype == "?" then
    return "<CR><cmd>nohl<CR>"
  end
  return "<CR>"
end, { expr = true })

vim.keymap.set("n", "<CR>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return vim.keycode "<CR>"
  end
end, { expr = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "qf", "fugitive" },
    callback = function()
        vim.opt_local.cursorline = true
    end,
})
