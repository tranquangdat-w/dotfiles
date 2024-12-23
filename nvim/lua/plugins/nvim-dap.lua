return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-dap.nvim'
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local telescope = require("telescope")
    telescope.load_extension("dap")

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "»" },
      mappings = {
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
            { id = 'scopes', size = 0.5 },
            { id = 'breakpoints', size = 0.3 },
            { id = 'stacks', size = 0.2 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = { 'repl', 'console' },
          size = 10,
          position = 'bottom',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
      },
      controls = {
        enabled = true,
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

    require("dap-python").setup("uv")

    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.after.event_terminated["dapui_config"] = function() dapui.open() end

    vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, { desc = 'Set breakpoint for debug' })

    local function continue_debug()
      if dap.session() then
        dap.continue()
      else
        telescope.extensions.dap.configurations()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
        dap.continue()
      end
    end

    vim.keymap.set('n', '<F11>', continue_debug, { desc = "Find debug configurations or continue debug" })
    vim.keymap.set('n', '<Leader>dc', continue_debug, { desc = "Find debug configurations or continue debug" })

    vim.keymap.set('n', '<F12>', function()
      dap.terminate()
      dapui.close()
    end, { desc = 'Close dapui' })

    vim.o.background = "dark"
    vim.cmd([[colorscheme gruvbox]])
  end
}

