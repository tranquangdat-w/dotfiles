return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        --
        inverse = false,
        transparent_mode = true
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
