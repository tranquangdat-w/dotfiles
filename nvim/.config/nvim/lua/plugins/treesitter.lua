return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.config")

    config.setup({
      ensure_installed = { "lua", "vim", "vimdoc", "java", "python", "javascript", "html", "css", "json", "gitignore", "sql", "go", "kotlin", "bash", "typescript", "markdown" },
      sync_install = false,
      ignore_install = {},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
