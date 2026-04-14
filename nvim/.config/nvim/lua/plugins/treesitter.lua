return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    local ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "java",
      "python",
      "javascript",
      "html",
      "css",
      "json",
      "gitignore",
      "sql",
      "go",
      "kotlin",
      "bash",
      "typescript",
      "markdown",
      "tsx",
    }
    local alreadyInstalled = require('nvim-treesitter.config').get_installed()
    local parsersToInstall = vim.iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
    require('nvim-treesitter').install(parsersToInstall)
    require("nvim-treesitter").setup({
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
