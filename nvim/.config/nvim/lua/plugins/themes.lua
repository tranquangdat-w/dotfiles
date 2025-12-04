return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        --
        -- terminal_colors = true, -- add neovim terminal colors
        -- contrast = "soft",      -- can be "hard", "soft" or empty string
        -- inverse = false,
        transparent_mode = true,
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = false,
        bold = true,
        italic = {
            strings = true,
            emphasis = false,
            comments = true,
            operators = false,
            folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
      })
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true
      })
      -- vim.cmd([[colorscheme catppuccin]])
    end,
  },
  -- lua/plugins/rose-pine.lua
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "moon", -- auto, main, moon, or dawn
        styles = {
          transparency = true
        }
      })
    end
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require('nightfox').setup({
        options = {
          transparent = true,
          styles = {
            comments = "italic",
            conditionals = "bold",
            constants = "bold",
            functions = "bold",
            keywords = "italic,bold",
            numbers = "bold",
            strings = "italic",
            types = "bold",
          }
        }
      })
    end
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require('kanagawa').setup({
        transparent = true
      })
    end
  }
}
