return {
  "roobert/tailwindcss-colorizer-cmp.nvim",

  dependencies = { "NvChad/nvim-colorizer.lua", "hrsh7th/nvim-cmp" },
  config = function()
    local mvchadcolorizer = require("colorizer")
    local tailwindcolorizer = require("tailwindcss-colorizer-cmp")
    local cmp = require("cmp")

    mvchadcolorizer.setup({
      user_default_options = {
        tailwind = true,
      },
      filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "vue", "svelte" }

    })

    tailwindcolorizer.setup({
      color_square_width = 2,
    })

    cmp.setup({
      formatting = { format = require("tailwindcss-colorizer-cmp").formatter },
    })

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      callback = function()
        vim.cmd("ColorizerAttachToBuffer")
      end
    })
  end
}
