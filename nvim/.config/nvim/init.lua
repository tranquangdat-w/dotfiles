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

-- Switch to English keyboard
local function force_english()
  vim.fn.jobstart({ "fcitx5-remote", "-s", "keyboard-us" }, { detach = true })
end

-- Switch to Vietnamese Unikey
local function force_unikey()
  vim.fn.jobstart({ "fcitx5-remote", "-s", "unikey" }, { detach = true })
end

-- Auto switch to English when leaving insert/cmdline
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter", "CmdlineLeave" }, {
  callback = force_english,
})

local vn_enabled = false

vim.api.nvim_create_user_command("ToggleUnikey", function()
  vn_enabled = not vn_enabled

  if vn_enabled then
    print("Vietnamese ON")
  else
    print("Vietnamese OFF")
    force_english()
  end
end, {})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if vn_enabled then
      force_unikey()
    end
  end,
})

-- DadbodUI
vim.g.db_ui_force_echo_notifications = 1

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Toggle undo tree" })

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#7dd3fc" })
vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#f9a8d4" })
