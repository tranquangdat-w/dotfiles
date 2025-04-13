return {
  {
  "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      window = {
    layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
    width = 0.9, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.9, -- fractional height of parent, or absolute height in rows when > 1
  },
    },
  },
  {
    vim.keymap.set('n', '<leader>p', '<cmd>CopilotChatToggle<CR>', { desc = 'Toggle Copilot Chat' })
  }
}
