 return {
   {
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
   },
   {
      -- Copilot
      vim.keymap.set("n", "<leader>ccp", function()
        require("CopilotChat.integrations.telescope").pick(
          require("CopilotChat.actions").prompt_actions(),
          require("telescope.themes").get_dropdown({
            previewer = false,
            prompt_title = "Copilot Actions",
            width = 1,
            height = 1,
          })
        )
      end, { desc = "CopilotChat - Prompt actions" }),
      vim.api.nvim_set_keymap('n', '<leader>p', ':CopilotChatToggle<CR>', { noremap = false })
   }
}

