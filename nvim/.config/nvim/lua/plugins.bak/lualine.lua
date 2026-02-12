return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local color = "#fb4934";
    -- Component zoom của bạn
    local function IsZoomedIn()
      if vim.t['simple-zoom'] == nil then
        vim.o.showtabline = 2
        return ''
      elseif vim.t['simple-zoom'] == 'zoom' then
        return 'Zoom'
      end
    end

    -- Component hiển thị diagnostic mode
    local function DiagMode()
      if vim.g.minimal_diagnostic then
        return "Diag:Off"
      else
        return ""
      end
    end

    require('lualine').setup {
      options = {
        -- theme = 'gruvbox_dark',
        theme = 'rose pine'
      },
      sections = {
        lualine_c = {
          {
            'filename',
          },
          {
            IsZoomedIn,
            color = { fg = color},
          },
          {
            DiagMode,
            color = { fg = color}, -- màu bạn có thể đổi
          },
        },
      },
    }
  end
}
