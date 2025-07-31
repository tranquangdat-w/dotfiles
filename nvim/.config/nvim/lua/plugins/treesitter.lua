return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "lua", "vim", "vimdoc", "java", "python", "javascript", "html", "css", "json", "gitignore", "sql", "go" },
      sync_install = false,
      ignore_install = {},
      modules = {},
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
