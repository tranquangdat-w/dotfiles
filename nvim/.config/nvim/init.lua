local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
require("vim-options")
require("vim-helpers")
require("floating-term")
require("lazy").setup("plugins")

vim.cmd([[colorscheme gruvbox]])

-- Kết quả tìm kiếm thông thường: nền trắng, chữ đỏ
vim.api.nvim_set_hl(0, 'Search', { fg = '#FF0000', bg = '#FFFFFF', bold = true })

-- Kết quả tìm kiếm hiện tại: nền đỏ, chữ trắng
vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#FFFFFF', bg = '#FF0000', bold = true })

-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "orange" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#a89984" })

vim.cmd("Copilot disable")

require('leap').set_default_mappings()
