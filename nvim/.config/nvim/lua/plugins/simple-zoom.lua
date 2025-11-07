return {
  "fasterius/simple-zoom.nvim",
  config = function()
    vim.keymap.set('n', '<C-w>z', require('simple-zoom').toggle_zoom)
  end
}
