return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = { theme = 'gruvbox_dark' },
      -- options = { theme = 'catppuccin' },
      sections = {
        lualine_c = {
          {
            'filename',
            -- path = 1,
            color = { fg = '#ebdbb2' }, -- Gruvbox colors
          },
        },
      },
    }
  end
}
