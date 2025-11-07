return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function IsZoomedIn()
      if vim.t['simple-zoom'] == nil then
        return ''
      elseif vim.t['simple-zoom'] == 'zoom' then
        return 'Zoom'
      end
    end

    require('lualine').setup {
      options = { theme = 'gruvbox_dark' },
      -- options = { theme = 'catppuccin' },
      -- options = { theme = 'nightfox' },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
            color = { fg = '#ebdbb2' }, -- Gruvbox colors
          },
          { IsZoomedIn },
        },
      },
    }
  end
}
