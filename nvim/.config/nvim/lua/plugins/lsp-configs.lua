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
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      vim.keymap.set('n', '<leader>lt', function()
        local mode = vim.api.nvim_get_mode().mode
        local filetype = vim.bo.filetype
        if mode == 'n' and filetype ~= "oil" and filetype ~= "sql" then
          vim.lsp.buf.format()
        end
      end, { desc = "Format current buffer" })

      -- lua
      vim.lsp.config['lua_ls'] = {
        cmd = { "lua-language-server" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }

      vim.lsp.config['ts_ls'] = {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",        -- Hiển thị tên tham số
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true, -- Hiển thị kiểu tham số hàm
              includeInlayVariableTypeHints = true,          -- Hiển thị kiểu biến
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }

      vim.lsp.config['eslint'] = {
        capabilities = capabilities,
      }

      vim.lsp.config['zls'] = {
        capabilities = capabilities,
      }

      vim.lsp.config['yamlls'] = {
        capabilities = capabilities,
      }

      vim.lsp.config['tailwindcss'] = {
        capabilities = capabilities,
      }

      vim.lsp.config['gopls'] = {
        capabilities = capabilities,
      }

      -- nix
      vim.lsp.config['rnix'] = {
        capabilities = capabilities,
      }

      -- protocol buffer
      vim.lsp.config['buf_ls'] = {
        capabilities = capabilities,
      }

      -- docker compose
      vim.lsp.config['docker_compose_language_service'] = {
        capabilities = capabilities,
      }

      -- cobol
      vim.lsp.config['cobol_ls'] = {
        capabilities = capabilities,
      }

      -- svelte
      vim.lsp.config['svelte'] = {
        capabilities = capabilities,
      }

      -- python
      vim.lsp.config['pyright'] = {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                callArgumentNames = "all", -- hoặc "none" nếu muốn tắt
                propertyDeclarationTypes = true,
                parameterTypes = true,
              },
            },
          },
        },
        on_attach = function(_, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,
      }

      -- bash
      vim.lsp.config['bashls'] = {
        capabilities = capabilities,
      }

      -- protocol buffer (kích hoạt riêng theo filetype)
      vim.lsp.config['buf_language_server'] = {
        capabilities = capabilities,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "proto",
        callback = function()
          vim.lsp.enable('buf_language_server')
        end,
      })
      vim.lsp.enable({
        'lua_ls',
        'ts_ls',
        'eslint',
        'zls',
        'yamlls',
        'tailwindcss',
        'gopls',
        'rnix',
        'buf_ls',
        'docker_compose_language_service',
        'cobol_ls',
        'svelte',
        'pyright',
        'bashls'
      })

      -- lsp kepmap setting
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, {})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

      vim.keymap.set("n", "<leader>ih", function()
        local enabled = vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(not enabled)
      end, { desc = "Toggle Inlay Hints" })
    end,
  },
}
