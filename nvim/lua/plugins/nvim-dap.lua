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

    dapui.setup(
    {
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.4
              }, {
                id = "breakpoints",
                size = 0.25
              }, {
                id = "stacks",
                size = 0.25
              }, {
                id = "watches",
                size = 0.1
              } },
            position = "left",
            size = 40
          }, {
            elements = { {
                id = "repl",
                size = 0.25
              }, {
                id = "console",
                size = 0.75
              } },
            position = "bottom",
            size = 10
          } },
      }
    )

    -- for python: need install debugpy => 
    -- mkdir ~/.virtualenvs
    -- cd ~/.virtualenvs
    -- python -m venv debugpy
    -- debugpy/bin/python -m pip install debugpy
    require("dap-python").setup("/home/dat/.virtualenvs/debugpy/bin/python")

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
    vim.keymap.set('n', '<Leader>do', dapui.toggle, {desc = 'Toggle DAP UI'})
  end
}
