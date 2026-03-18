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
        -- winopts = {
        --   height = 0.85,
        --   width = 0.90,
        -- },
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

      vim.keymap.set("n", "<leader>ff", function() require("aerial").fzf_lua_picker({}) end,
        { desc = "Open Aerial (functions only)" })

      vim.keymap.set("n", "<leader>m", ":AerialToggle<CR>")

      -- Tùy chỉnh màu số dòng trong grep
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { bg = "#1e1e1e", bold = true })

      vim.keymap.set("n", "<leader><leader>", function()
        require("fzf-lua").files({
          fd_opts =
          "--type f --hidden --exclude '*.class' --exclude 'app/bin' --exclude 'node_modules' --exclude '.git' --exclude .gradle --exclude .settings --exclude 'build'",
          previewer = false,
        })
      end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", fzf.git_status, { desc = "Find Git status Files" })
      vim.keymap.set("n", "<leader>fs", fzf.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fm", fzf.marks, { desc = "Find marks" })
      vim.keymap.set("n", "<leader>fS", function()
        require("fzf-lua").live_grep({
          rg_opts = "--hidden --glob '!.git/*' --column --line-number --no-heading --color=always -e",
        })
      end, { desc = "Live Grep includes hidden files" })
      vim.keymap.set("n", "<leader>,", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>/", fzf.grep_curbuf, { desc = "Grep in Current Buffer" })
      vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Resume fzf serach" })
      vim.keymap.set("n", "<leader>fq", fzf.quickfix_stack, { desc = "Open quickfix history" })
    end,
  }
}
