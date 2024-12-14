return {
  -- UFO folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype)
        if filetype == "html" or filetype == "javascript" or filetype == "css" then
          return { "treesitter", "indent" }
        else
          return { "indent" }
        end
      end,
    },
    init = function()
      -- Phím tắt để mở/đóng fold
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end, { desc = "Close all folds" })
    end,
  },
  -- Folding preview
  {
    "anuvyklack/fold-preview.nvim",
    dependencies = "anuvyklack/keymap-amend.nvim",
    config = true,
  },
}
