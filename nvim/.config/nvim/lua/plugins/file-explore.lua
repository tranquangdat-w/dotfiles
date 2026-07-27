return {
  {
    "stevearc/oil.nvim",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      local oil = require("oil")

      local function update_winbar()
        if vim.bo.filetype ~= "oil" then
          return
        end

        local dir = oil.get_current_dir()
        if not dir then
          return
        end

        vim.wo.winbar =  vim.fn.fnamemodify(dir, ":.")
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = update_winbar,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilDirChanged",
        callback = update_winbar,
      })
      require("oil").setup({
        default_file_explorer = true,
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
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-r>"] = "actions.refresh",
          ["<Tab>"] = { "actions.parent", mode = "n" },
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
      { "-", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Open tree at current file" },
    },

    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del("n", "-", { buffer = bufnr })
      end
      require("nvim-tree").setup({
        on_attach = on_attach,
        update_focused_file = {
          enable = false,
          update_root = false, -- đổi thành true nếu muốn root đổi theo file
        },
        filesystem_watchers = {
          enable = false,
        },
        sort = {
          sorter = "case_sensitive"
        },
        view = {
          side = "right",
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get()
              local width = math.floor(screen_w * 1.0)
              local height = math.floor(screen_h * 1.0)
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
            enable = false,
          },
          group_empty = true,
          indent_width = 4,
          highlight_modified = "icon",
          icons = {
            show = {
              git = true,
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
        "<leader>w",
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
        -- Open in the current working directory
        "<leader>_",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
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
    end,
  }
}
