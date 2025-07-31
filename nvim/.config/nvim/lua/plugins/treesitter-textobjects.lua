return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        move = {
          enable = true,
          set_jumps = false, -- lưu vào jumplist
          goto_next_start = {
            ["<leader>nf"] = "@function.outer",
          },
          goto_previous_start = {
            ["<leader>pf"] = "@function.outer",
          },
        },
      },
    })
  end,
}
