return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    vim.api.nvim_set_keymap(
      'n',
      '<leader>t',
      ':NvimTreeToggle<CR>',
      { noremap = true, silent = true }
    )

    vim.api.nvim_set_keymap(
      'n',
      '<leader>vt',
      ':NvimTreeFindFileToggle<CR>',
      { noremap = true, silent = true }
    )

    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive"
      },
      view = {
        float = {
          enable = false,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get()
            local width = math.floor(screen_w * 0.4)
            local height = math.floor(screen_h * 0.95)
            local row = math.floor((screen_h - height) / 2)
            local col = math.floor((screen_w - width) / 2)
            return {
              relative = "editor",
              border = "rounded",
              width = width,
              height = height,
              row = row,
              col = col,
            }
          end,
        },
        width = 35
      },
      git = {
        ignore = false,
      },
      renderer = {
        -- group_empty = true,
        indent_width = 0.1,
        highlight_modified = "icon",
        icons = {
          show = {
            git = false,
            file = true,
            folder = false,
            folder_arrow = true,
            modified = true,
          },
          glyphs = {
            modified = "●",
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "⌥",
              renamed = "➜",
              untracked = "★",
              deleted = "⊖",
              ignored = "◌",
            },
          },
        },
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
    })
  end
}
