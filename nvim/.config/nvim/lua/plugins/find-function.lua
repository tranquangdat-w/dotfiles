return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local aerial = require("aerial")
    aerial.setup({
      layout = {
        min_width = 30,
        default_direction = "left",
      }
    })

    local actions = require("telescope.actions")
    local telescope = require("telescope")
    local conf = require("telescope.config").values

    telescope.setup({
      defaults = {
        -- file_ignore_patterns = {"%.class"},
        sorting_strategy = "ascending",
        layout_strategy = "vertical",

        layout_config = {
          prompt_position = "top", -- Với `center` thì prompt luôn ở trên
          height = 0.8,
          width = 0.85,
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-u>"] = false,
            ["<Esc>"] = actions.close,
          },
          n = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<Esc>"] = actions.close,
            ["<C-u>"] = false,
          },
        },
      },
    })

    telescope.load_extension("aerial")
    local harpoon = require('harpoon')
    harpoon:setup({})

    -- basic telescope configuration
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<leader>fh", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" })

    vim.keymap.set("n", "<leader>nf", ":AerialNext<CR>", { desc = "Move to next function" })
    vim.keymap.set("n", "<leader>nf", ":AerialPrev<CR>", { desc = "Move to previous function" })

    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
    -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
    -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })

    vim.keymap.set(
      "n", "<leader>fm", ":Telescope aerial<CR>",
      { desc = "Open Aerial symbols with Telescope" }
    )

    vim.keymap.set("n", "<leader>m", ":AerialToggle<CR>")
  end,
}
