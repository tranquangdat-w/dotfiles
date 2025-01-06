require("config.lazy")

vim.cmd [[
  autocmd FileType * setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
]]

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- require("ibl").setup()
-- -- UFO folding
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
vim.keymap.set("n", "<Leader>4", function() harpoon:list():select(4) end, {desc = 'Go to harpoon 4'})
