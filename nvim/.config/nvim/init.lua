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
require("vim-options")
require("vim-helpers")
require("floating-term")
require("lazy").setup("plugins")

-- vim.cmd([[colorscheme catppuccin]])
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme nightfox]])
vim.cmd("colorscheme rose-pine-moon")

-- Get current WinBar highlight to preserve its background color
local winbar_hl = vim.api.nvim_get_hl(0, { name = "WinBar", link = false })

vim.api.nvim_set_hl(0, "WinBar", { fg = "#ffffff", bg = winbar_hl.bg, })

-- Disable Copilot
-- vim.cmd("Copilot disable")

-- DadbodUI
vim.g.db_ui_force_echo_notifications = 1

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Toggle undo tree" })

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#7dd3fc" })
vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#f9a8d4" })
-- require('vim._core.ui2').enable({msg={target='cmd'}})
