return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- branch = 'master',
  requires = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    -- Keymaps for Telescope
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })

    -- Telescope setup
    telescope.setup {
      defaults = {
        file_ignore_patterns = {"%.class"},
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            width = 0.9,
            preview_cutoff = 10,
          },
        },
      },
    }
  end
}
