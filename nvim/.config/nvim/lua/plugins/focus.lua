return {
  "folke/twilight.nvim",
  config = function()
    require("twilight").setup({
      context = 0,
      expand = {
        "function",
        "function_definition",
        "method",
        "method_definition",
        "function.outer",
      },
    })

    -- Highlight cho vùng không được focus
    vim.api.nvim_set_hl(0, "Twilight", { fg = "#777777" })

    vim.keymap.set("n", "<leader>fc", ":Twilight<CR>", { desc = "Toggle focus mode" })
  end,
}

