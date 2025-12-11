return {
  'goolord/alpha-nvim',
  config = function()
    local dashboard = require 'alpha.themes.dashboard'
    dashboard.section.buttons.val = {
      dashboard.button("SPC v v", "  Open Oil"),
      dashboard.button("SPC f f", "  Find File"),
      dashboard.button("SPC f g", "󰱽  Live Grep"),
      dashboard.button("SPC f b", "  Buffers"),
      dashboard.button("SPC f s", "  Grep with input"),
      dashboard.button("SPC f w", "󰈬  Grep in Current Buffer"),
    }
    require 'alpha'.setup(dashboard.config)
  end
};
