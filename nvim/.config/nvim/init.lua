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

-- vim.cmd([[colorscheme catppuccin]])
vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme nightfox]])
-- vim.cmd("colorscheme rose-pine")

local winbar_hl = vim.api.nvim_get_hl(0, { name = "WinBar", link = false })

vim.api.nvim_set_hl(0, "WinBar", { fg = "#ffffff", bg = winbar_hl.bg,
})

vim.api.nvim_set_hl(0, 'Search', { fg = '#282828', bg = '#fabd2f', bold = true })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#282828', bg = '#fe8019', bold = true })

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "orange" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#a89984" })

-- Disable Copilot
vim.cmd("Copilot disable")

-- convert to english input
local function force_english()
  vim.fn.jobstart({ "ibus", "engine", "xkb:us::eng" }, { detach = true })
end

local function force_unikey()
  vim.fn.jobstart({ "ibus", "engine", "Unikey" }, { detach = true }) -- hoặc "ibus-unikey" nếu bạn dùng ibus-unikey
end

-- when leave insertMode change input method to english
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter", "CmdlineLeave" }, {
  callback = force_english,
})

local ibus_switch_enabled = false

-- FOR VIETNAMESE
vim.api.nvim_create_user_command("ToggleUnikey", function()
  ibus_switch_enabled = not ibus_switch_enabled
end, {})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if ibus_switch_enabled then
      force_unikey()
    end
  end
})

-- DadbodUI
vim.g.db_ui_force_echo_notifications = 1

vim.api.nvim_set_hl(0, "TreesitterContext", {
  bg = "#1e1e1e", -- Màu nền hơi tối (tùy theme)
  bold = true,    -- Chữ đậm
})

vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
  fg = "#858585", -- Giống màu line number
})
