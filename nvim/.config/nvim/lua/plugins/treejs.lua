return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = { { '<leader>j', function() require('treesj').toggle() end, desc = 'Toggle join/split' } },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}

