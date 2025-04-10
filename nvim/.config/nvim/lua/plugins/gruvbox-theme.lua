return {
	  "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        inverse = false,
        transparent_mode = true
      })
    -- vim.cmd([[colorscheme catppuccin]])
      vim.cmd([[colorscheme gruvbox]])

    end
}
