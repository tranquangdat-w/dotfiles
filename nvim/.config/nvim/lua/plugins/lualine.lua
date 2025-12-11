return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function IsZoomedIn()
      if vim.t['simple-zoom'] == nil then
        vim.o.showtabline = 2
        return ''
      elseif vim.t['simple-zoom'] == 'zoom' then
        return 'Zoom'
      end
    end

    require('lualine').setup {
      options = { theme = 'gruvbox_dark' },
      -- options = { theme = 'rose-pine' },
      -- options = { theme = 'catppuccin' },
      -- options = { theme = 'nightfox' },
      sections = {
        lualine_c = {
          {
            'filename',
            -- path = 1,
            -- color = { fg = '#ebdbb2' }, -- Gruvbox colors
          },
          {
            IsZoomedIn,
            color = { fg = '#fb4934' },
          },
        },
      },
    }
  end
}
