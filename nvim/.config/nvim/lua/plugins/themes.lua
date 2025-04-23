return {
{
	  "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
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
}
}
