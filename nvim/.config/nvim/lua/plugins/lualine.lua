return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = { theme = 'gruvbox_dark' },
      -- options = { theme = 'catppuccin' },
      --  p
      --
      sections = {
        lualine_c = {
          {
            'filename',
            color = { gui = 'bold' }, -- đổi màu ở đây
          },
        },
      },
    }
  end
}
