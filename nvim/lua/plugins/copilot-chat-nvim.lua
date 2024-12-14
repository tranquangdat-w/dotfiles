  return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },            -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },         -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
    },
    opts = {
      debug = true, -- Enable debugging
      show_help = true, -- Show help actions
      window = {
        layout = "float",
        width = 0.9,
        height = 0.8,
      },
      auto_follow_cursor = false,    -- Don't follow the cursor after getting response
    },
}

