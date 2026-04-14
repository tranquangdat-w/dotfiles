return {
  'gelguy/wilder.nvim',
  config = function()
    local wilder = require('wilder')
    wilder.setup(
      {
        modes = { ':', '/', '?' },
        next_key = "<C-j>",
        previous_key = "<C-k>"
      }
    )
    wilder.set_option('renderer', wilder.popupmenu_renderer({
      highlighter = wilder.basic_highlighter(),
    }))
  end
}
