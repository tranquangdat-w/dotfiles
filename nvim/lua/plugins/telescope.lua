return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  requires = { {'nvim-lua/plenary.nvim'} },
  config = function()
    require('telescope').setup {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = { 
            width  = 0.9,
            preview_cutoff = 10,
          }
        },
      }
    }
  end
}
