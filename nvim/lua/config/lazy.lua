-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

vim.api.nvim_set_option("clipboard", "unnamed")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- To copy in clipboard in vim
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- Đặt phím Esc để chuyển về normal mode trong terminal
vim.cmd([[ 
  autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
]])

vim.keymap.set("n", "<C-\\>", function()
    -- Kiểm tra xem có phải là terminal hay không
    local buf_type = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype')
    
    -- Nếu đang trong terminal, đóng terminal
    if buf_type == 'terminal' then
        vim.cmd('bd!')  -- Đóng buffer terminal mà không hỏi xác nhận
    else
        -- Nếu không phải terminal, mở terminal mới trong tab mới
        vim.cmd('tabnew')  -- Mở tab mới
        vim.cmd('term')    -- Tạo terminal trong tab mới
        vim.cmd('startinsert')  -- Chuyển sang chế độ insert
    end
end, { desc = "Toggle terminal in new tab" })

vim.keymap.set('n', '<C-Esc>', function()
    if vim.bo.buftype == 'terminal' then
        vim.cmd('bd!')
    else
        vim.cmd('bd')
    end
end, { noremap = true, silent = true })

