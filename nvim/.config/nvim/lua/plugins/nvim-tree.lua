return {
  "nvim-tree/nvim-tree.lua",
  lazy=true,
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    { "<leader>E", "<cmd>NvimTreeToggle<CR>", desc = "Find file in NvimTree" },
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
        update_root = false, -- đổi thành true nếu muốn root đổi theo file
      },
      filesystem_watchers = {
        enable = true,
      },
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
        width = 50
      },
      git = {
        ignore = false,
        show_on_open_dirs = false,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        group_empty = true,
        -- indent_width = 0.1,
        highlight_modified = "icon",
        icons = {
          show = {
            git = true,
            file = true,
            folder = true,
            folder_arrow = false,
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
