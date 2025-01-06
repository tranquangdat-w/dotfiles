return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  requires = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    -- Keymaps for Telescope
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fm', builtin.marks, {})

    -- Telescope setup
    telescope.setup {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            width = 0.9,
            preview_cutoff = 10,
          },
        },
      },
      pickers = {
        buffers = {
          initial_mode = "normal",
          mappings = {
            n = { ["dd"] = actions.delete_buffer },
          },
        },
        find_files = { initial_mode = "normal" },
        live_grep = { initial_mode = "normal" },
        help_tags = { initial_mode = "normal" },
      },
    }
  end
}

