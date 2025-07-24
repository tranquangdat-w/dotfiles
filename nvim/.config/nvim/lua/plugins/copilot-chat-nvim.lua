return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      window = {
        layout = 'vertical',   -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
        width = 0.4,           -- fractional width of parent, or absolute width in columns when > 1
        height = 1.0,          -- fractional height of parent, or absolute height in rows when > 1
      },
      auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
      mappings = {
        complete = {
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
      },
    }
  },
  {
    vim.keymap.set('n', '<leader>q', '<cmd>CopilotChatToggle<CR>', { desc = 'Toggle Copilot Chat' }),
  },
}
