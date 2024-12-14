return {
  -- :bufdo bd this comment will close all buffers
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  require('telescope').setup {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        vertical = { 
          width  = 0.9,
          preview_cutoff = 10,
        }
      },
      mappings = {
        i = {}, -- Leave insert mode mappings unchanged
        n = {
          ["dd"] = require('telescope.actions').delete_buffer,
        }
      }
    }
  }
}
