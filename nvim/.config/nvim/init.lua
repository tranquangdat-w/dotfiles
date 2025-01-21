require("config.lazy")
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.cmd [[
  autocmd FileType * setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
]]

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- UFO folding
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.buttons.val = {
    dashboard.button("e", "New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "Recently used files", ":Telescope oldfiles<CR>"),
    dashboard.button("s", "Settings", ":e $MYVIMRC<CR>"),
    dashboard.button("q", "Quit", ":qa!<CR>"),
}

-- Chỉnh sửa chân trang
dashboard.section.footer.val = {
    "⚡Stay productive!",
}

-- Kích hoạt Alpha
alpha.setup(dashboard.opts)

-- Copilot
vim.keymap.set("n", "<leader>ccp", function()
  require("CopilotChat.integrations.telescope").pick(
    require("CopilotChat.actions").prompt_actions(),
    require("telescope.themes").get_dropdown({
      previewer = false,
      prompt_title = "Copilot Actions",
      width = 1,
      height = 1,
    })
  )
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "CopilotChat - Prompt actions" })

vim.api.nvim_set_keymap('n', '<leader>p', ':CopilotChat<CR>', { noremap = true, silent = true })

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<Leader>a", function() harpoon:list():add() end, {desc = 'Add to harpoon'})
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<Leader>1", function() harpoon:list():select(1) end, {desc = 'Go to harpoon 1'})
vim.keymap.set("n", "<Leader>2", function() harpoon:list():select(2) end, {desc = 'Go to harpoon 2'})
vim.keymap.set("n", "<Leader>3", function() harpoon:list():select(3) end, {desc = 'Go to harpoon 3'})
vim.keymap.set("n", "<C-w>h", "<C-w>v")
vim.keymap.set("n", "<C-w>v", "<C-w>s")

-- Tùy chỉnh để hiển thị floating window khi rename
local function rename_with_floating_window()
  local current_name = vim.fn.expand("<cword>") -- Từ hiện tại
  vim.ui.input(
    { prompt = "Rename to: ", default = current_name },
    function(new_name)
      if new_name and #new_name > 0 then
        vim.lsp.buf.rename(new_name)
      end
    end
  )
end

-- Gán keymap cho rename với floating window
vim.keymap.set("n", "<leader>rn", rename_with_floating_window, { desc = "LSP Rename with Floating Window" })

require("floating-term")
require("vim-helpers")

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
