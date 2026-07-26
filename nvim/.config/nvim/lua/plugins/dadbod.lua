return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = false },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = false },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_auto_execute_table_helpers = 0 -- không tự chạy khi chọn helper
      vim.g.db_ui_execute_on_save = 0            -- không tự execute query khi :w
      vim.g.db_ui_win_position = 'left'          -- 'left' hoặc 'right'

      -- Table helpers: query có sẵn khi expand table trong drawer.
      -- Không tự execute (execute_on_save=0) → mở template để điền rồi <C-s> chạy.
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'select count(*) from {optional_schema}{table};',
          ['Last 100'] = 'select * from {optional_schema}{table} order by id desc limit 100;',
          ['Select Where'] = 'SELECT * FROM {optional_schema}{table} WHERE ',
          ['Delete'] =
          'SELECT * FROM {optional_schema}{table};\nSELECT * FROM {optional_schema}{table} WHERE id = :varUp;\nDELETE FROM {optional_schema}{table} WHERE id = :varUp;',
          ['Update'] =
          'SELECT * FROM {optional_schema}{table};\nSELECT * FROM {optional_schema}{table} WHERE id = :varDel;\nUPDATE {optional_schema}{table} SET \nWHERE id = :varDel;',
        },
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbout',
        callback = function()
          require('dbout-context').attach({ context_lines = 2 }) -- 2 để lấy cả dòng tên cột + dòng gạch ngang
          vim.cmd('resize ' .. math.floor(vim.o.lines * 0.5))    -- kết quả query cao 50% màn hình
        end,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbui',
        callback = function(args)
          -- Mapping kiểu nvim-tree cho drawer. Lưu ý: <Plug> cần remap = true.
          local o = { buffer = args.buf, remap = true, silent = true }
          vim.keymap.set('n', 'P', '<Plug>(DBUI_GotoParentNode)', o)       -- node cha
          vim.keymap.set('n', '<C-v>', '<Plug>(DBUI_SelectLineVsplit)', o) -- mở split dọc
          -- siblings: J/K nhảy sibling cuối/đầu, bỏ <C-j>/<C-k> mặc định
          pcall(vim.keymap.del, 'n', '<C-j>', { buffer = args.buf })
          pcall(vim.keymap.del, 'n', '<C-k>', { buffer = args.buf })
          vim.keymap.set('n', 'J', '<Plug>(DBUI_GotoLastSibling)', o)
          vim.keymap.set('n', 'K', '<Plug>(DBUI_GotoFirstSibling)', o)
          -- >/< nhảy sibling kế/trước
          vim.keymap.set('n', '>', '<Plug>(DBUI_GotoNextSibling)', o)
          vim.keymap.set('n', '<', '<Plug>(DBUI_GotoPrevSibling)', o)
        end,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function(args)
          -- Normal mode: tự select dòng hiện tại (V) rồi execute như visual
          -- -> chỉ chạy 1 dòng cursor NHƯNG vẫn qua đường bind parameters của dadbod-ui
          vim.keymap.set('n', '<C-s>', 'V<Plug>(DBUI_ExecuteQuery)', {
            buffer = args.buf,
            desc = 'Execute current line (with bind params)',
          })
          -- Visual mode: giữ nguyên execute selection
          vim.keymap.set('v', '<C-s>', '<Plug>(DBUI_ExecuteQuery)', {
            buffer = args.buf,
            desc = 'Execute selection (with bind params)',
          })
        end,
      })
    end,
  },
  {
    "joryeugene/dadbod-grip.nvim",
    version = "*",
    cmd = { "Grip", "GripStart", "GripHome", "GripConnect", "GripSchema", "GripTables", "GripQuery", "GripSave", "GripLoad", "GripHistory", "GripProfile", "GripExplain", "GripAsk", "GripDiff", "GripCreate", "GripDrop", "GripRename", "GripProperties", "GripExport", "GripAttach", "GripDetach", "GripOpen" },
    lazy = false,
    config = function()
      require("dadbod-grip").setup({
        limit         = 100,
        max_col_width = 40,
        timeout       = 10000,
      })

      vim.keymap.set("n", "<leader>dg", "<cmd>GripTables<cr>", { desc = "Data grid: pick table" })

      -- Enum/boolean picker + esc-to-normal cell editor (see lua/grip-editor.lua)
      require("grip-editor").setup()
    end,
  },
}
