return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/aerial.nvim",
    },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        winopts = {
          preview = {
            layout = "vertical",
            vertical = "up:40%",
          },
        },
        fzf_colors = {
          true,
          bg = "-1",
          gutter = "-1",
        },
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        }
      })

      local aerial = require("aerial")
      aerial.setup({
        layout = {
          min_width = 30,
          default_direction = "left",
        },
      })

      local harpoon = require('harpoon')
      harpoon:setup({})

      vim.keymap.set("n", "<M-l>", function()
        local cor = vim.fn.systemlist("fd -t d --hidden --exclude '.git'")
        require("fzf-lua").fzf_exec(cor, {
          previewer = "shell",
          preview = "LS_COLORS='di=34:fi=37:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31' ls --color=always {}",
          actions = {
            ['default'] = function(selected, _)
              vim.cmd("Oil " .. vim.fn.fnamemodify(selected[1], ":p"))
            end,
          },
        })
      end, { desc = "Find Directories" })

      vim.keymap.set("n", "<A-m>", function() require("aerial").fzf_lua_picker({}) end,
        { desc = "Open Aerial (functions only)" })

      vim.keymap.set("n", "<leader>m", ":AerialToggle<CR>")

      -- Tùy chỉnh màu số dòng trong grep
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { bg = "#1e1e1e", bold = true })

      vim.keymap.set("n", "<leader><leader>", function()
        local cwd = nil

        if vim.bo.filetype == "oil" then
          cwd = require("oil").get_current_dir()
        end
        require("fzf-lua").files({
          cwd = cwd,
          fd_opts =
          "--type f --hidden --exclude '*.class' --exclude 'app/bin' --exclude 'node_modules' --exclude '.git' --exclude .gradle --exclude .settings --exclude 'build'",
          -- previewer = false,
        })
      end, { desc = "Find Files" })
      vim.keymap.set("n", "<A-g>", fzf.git_status, { desc = "Find Git status Files" })
      vim.keymap.set("n", "<A-;>", function()
        local cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil
        fzf.live_grep({ cwd = cwd })
      end, { desc = "Live Grep" })
      vim.keymap.set("n", "<A-'>", fzf.marks, { desc = "Find marks" })
      vim.keymap.set("n", "<A-.>", function()
        local cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil
        require("fzf-lua").live_grep({
          cwd = cwd,
          rg_opts = "--hidden --no-ignore --glob=!.git/* --glob=!**/node_modules/* --column --line-number --no-heading --color=always --smart-case -e",
        })
      end, { desc = "Live Grep includes hidden files" })
      vim.keymap.set("n", "<M-,>", function()
        fzf.buffers({
          previewer = false
        })
      end, { desc = "Buffers" })
      vim.keymap.set("n", "<M-/>", fzf.grep_curbuf, { desc = "Grep in Current Buffer" })
      vim.keymap.set("n", "<M-r>", fzf.resume, { desc = "Resume fzf serach" })
      vim.keymap.set("n", "<M-q>", fzf.quickfix_stack, { desc = "Open quickfix history" })
      vim.keymap.set("n", "<M-w>", function()
        require("fzf-lua").grep_cword({ rg_opts = "--word-regexp" })
      end)
    end,
  }
}
