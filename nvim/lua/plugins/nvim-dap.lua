return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope.nvim',  -- Add Telescope dependency
    'nvim-telescope/telescope-dap.nvim'  -- Add Telescope DAP extension
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local telescope = require("telescope")
    local telescope_dap = require("telescope").load_extension("dap")

    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "»" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              'scopes',
              -- 'breakpoints',
              'stacks',
              -- 'watches',
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              'repl',
              'console',
            },
            size = 10,
            position = 'bottom',
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "rounded", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true, -- because the icons don't work
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        windows = { indent = 1 },
      })

    -- for python: need install debugpy => 
    -- mkdir ~/.virtualenvs
    -- cd ~/.virtualenvs
    -- python -m venv debugpy
    -- debugpy/bin/python -m pip install debugpy
    require("dap-python").setup("uv")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.after.event_terminated["dapui_config"] = function()
      dapui.open()
    end
    
    vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {desc = 'Set breakpoint for debug'})
    vim.keymap.set('n', '<Leader>dc', function()
      if dap.session() then
        dap.continue()
      else
        telescope.extensions.dap.configurations()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
        dap.continue()
      end
    end, {desc = "Find debug configurations or continue debug"})
    vim.keymap.set('n', '<Leader>do', function()
        dap.terminate()
        dapui.close()
    end, { desc = 'Close DAP UI'})
    vim.o.background = "dark" -- or "light" for light mode
    vim.cmd([[colorscheme gruvbox]])
  end
}
