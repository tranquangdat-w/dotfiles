return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
    build = "make install_jsregexp",
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "rcarriga/cmp-dap",
      "onsails/lspkind.nvim",
    },
    opts = function()
      require("cmp").setup({
        enabled = function()
          if vim.bo.filetype == "oil" then
            return false
          end
          if vim.bo.filetype == "snacks_input" then
            return true
          end
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
      })

      require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
    config = function()
      local lspkind = require('lspkind')
      lspkind.init({})
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      local format = lspkind.cmp_format({
        mode = 'symbol',
        symbol_map = {
          Copilot = "",
          Codeium = ""
        },
        maxwidth = {
          -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- menu = function() return math.floor(0.45 * vim.o.columns) end,
          menu = 50,              -- leading text (labelDetails)
          abbr = 50,              -- actual suggestion item
        },
        ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          return vim_item
        end
      })

      vim.keymap.set("n", "<leader>nw", function()
        require("luasnip").jump(1)
      end, { silent = true })

      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
            vim_item = format(entry, vim_item)

            if entry.source.name == "copilot" then
              vim_item.kind = " Copilot"
              vim_item.kind_hl_group = "CmpItemKindCopilot"
            elseif entry.source.name == "codeium" then
              vim_item.kind = "󰘦 Codeium"
              vim_item.kind_hl_group = "CmpItemKindCodeium"
            end
            local menu = entry.source.name

            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            max_height = 24
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item()
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "zls" },
          { name = "buffer" },
          { name = "path" },
          { name = "pylsp" },
          { name = "gci" },
          { name = "ts_ls" },
          { name = "gopls" },
          { name = "vim-dadbod-completion" },
          { name = "copilot", group_index = 2 },
          { name = "codeium", group_index = 2 },
        }),
      })
    end,
  },
}
