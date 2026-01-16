return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({})
  end,
}
