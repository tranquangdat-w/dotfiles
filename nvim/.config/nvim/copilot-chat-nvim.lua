 return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },            -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },         -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
    },
    opts = {
      debug = false, -- Enable debugging
      show_help = true, -- Show help actions
      window = {
        layout = "float",
        width = 0.9,
        height = 0.9,
        title = "Copilot Chat",
      },
      auto_follow_cursor = false,    -- Don't follow the cursor after getting response
      question_header = '#T.Q.Dat',
      answer_header = '#Copilot',
    },
}

