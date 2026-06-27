return {
  {
    "stevearc/oil.nvim",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      require("oil").setup({
        columns = { 'icon' },
        use_default_keymaps = false,
        skip_confirm_for_simple_edits = true,
        confirmation = {
          border = "rounded",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, bufnr)
            return name == '..'
          end,
        },
        win_options = {
          cursorline = true,
        },
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["l"] = { "actions.select", mode = "n" },
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-r>"] = "actions.refresh",
          ["<Tab>"] = { "actions.parent", mode = "n" },
          ["h"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
      })
      vim.keymap.set("n", "<Tab>", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "_", "<CMD>Oil .<CR>", { desc = "Open parent directory" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>E", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Open tree at current file" },
    },
    config = function()
      require("nvim-tree").setup({
        -- update_focused_file = {
        --   -- enable = true,
        --   -- update_root = false, -- đổi thành true nếu muốn root đổi theo file
        -- },
        -- filesystem_watchers = {
        --   enable = true,
        -- },
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
          -- width = 50
        },
        git = {
          ignore = true,
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
  },
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>cw",
        function()
          if vim.bo.filetype == "oil" then
            require("yazi").yazi({}, require("oil").get_current_dir())
          else
            vim.cmd("Yazi")
          end
        end,
        desc = "Open Yazi",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      open_for_directories = false,
      floating_window_scaling_factor = 1,
      yazi_floating_window_border = "none",
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  }
}
