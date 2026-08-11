return {
  'goolord/alpha-nvim',

  event = 'VimEnter',
  cond = vim.fn.argc() == 0,
  config = function()
    local dashboard = require 'alpha.themes.dashboard'
    dashboard.section.buttons.val = {
      dashboard.button("<Tab>", "  Open Oil"),
      dashboard.button("<BS>f", "  Find File"),
      dashboard.button("<BS>;", "  Live Grep"),
      dashboard.button("<BS>,", "  Buffers"),
      dashboard.button("<BS>/", "  Grep in Current Buffer"),
    }
    require('alpha').setup(dashboard.config)
  end,
};
