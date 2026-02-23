return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "sindrets/diffview.nvim" },
    opts = {
      on_attach = function(bufnr)
        require("gitsigns").setup({
          preview_config = {
            border = "rounded",
          },
        })
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        -- navigation
        map("n", "]h", function()
          gs.next_hunk()
          vim.defer_fn(function()
            vim.cmd("normal! zz")
          end, 20)
        end, "Next hunk")

        map("n", "[h", function()
          gs.prev_hunk()
          vim.defer_fn(function()
            vim.cmd("normal! zz")
          end, 20)
        end, "Prev hunk")

        -- Actions
        map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")

        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>ghB", gs.toggle_current_line_blame, "Toggle line blame")
        -- diff
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff this ~")

        -- text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")

        vim.keymap.set('n', "<leader>gs", "<Cmd>Git<CR>", { desc = "Git status" })

        -- Diffview
        vim.keymap.set("n", "<leader>dv", function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end, { desc = "Toggle Diffview" })
      end,
    },
  },
  {
    'tpope/vim-fugitive'
  }
}
