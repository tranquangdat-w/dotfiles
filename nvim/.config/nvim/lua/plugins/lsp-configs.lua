return {
  {
    "williamboman/mason.nvim",
    -- NOTE: I comment it to install jdtls (java language server)
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "eslint",
        "zls",
        "yamlls",
        "tailwindcss",
        "bashls",
        "gopls",
        "jdtls",
        "html",
        "cssls",
        "sqls",
        "buf_ls",
        "docker_compose_language_service",
        "pylsp",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          local mode = vim.api.nvim_get_mode().mode
          local filetype = vim.bo.filetype
          if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" then
            vim.cmd('lua vim.lsp.buf.format()')
          else
          end
        end
      })

      -- lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- bash
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- typescript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
      -- Js
      lspconfig.eslint.setup({
        capabilities = capabilities,
      })
      -- zig
      lspconfig.zls.setup({
        capabilities = capabilities,
      })
      -- yaml
      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })
      -- tailwindcss
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })
      -- golang
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })

      -- -- java
      -- lspconfig.jdtls.setup({
      --   settings = {
      --     java = {
      --       configuration = {
      --         runtimes = {
      --           {
      --             name = "JavaSE-21",
      --             path = "/usr/lib/jvm/java-21-openjdk",
      --             default = true,
      --           },
      --         },
      --       },
      --     },
      --   },
      -- })

      -- html
      lspconfig.html.setup({
        capabilities = capabilities,
        filetypes = { "html", "htmldjango" },
      })

      -- css
      lspconfig.cssls.setup({
        capabilities = capabilities,
        filetypes = { "css", "scss", "less" },
      })

      -- nix
      lspconfig.rnix.setup({ capabilities = capabilities })

      lspconfig.sqls.setup({
        capabilities = capabilities,
        filetypes = { "sql", "mysql", "sqlite" },
        settings = {
          sqls = {
            connections = {
              {
                driver = "mysql",
                -- dataSourceName = "dat:1@tcp(127.0.0.1:3307)/sakila"
                -- dataSourceName = "dat:1@tcp(127.0.0.1:3307)/hr"
                dataSourceName = "dat:1@tcp(127.0.0.1:3307)/sms"

                -- driver = "postgresql",
                -- dataSourceName = 'host=127.0.0.1 port=5432 user=dat password=1 dbname=habitdb sslmode=disable',
              }
            }
          }
        }
      })

      -- protocol buffer
      lspconfig.buf_ls.setup({ capabilities = capabilities })

      -- docker compose
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })

      --python
      lspconfig.pylsp.setup({ capabilities = capabilities })

      -- lsp kepmap setting
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      -- list all methods in a file
      -- working with go confirmed, don't know about other, keep changing as necessary
    end,
  },
}
