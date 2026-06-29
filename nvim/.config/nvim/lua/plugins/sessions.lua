return {
  "folke/persistence.nvim",
  event = "VimEnter",
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Load session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Stop persistence" },
  },
  opts = {},
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    vim.schedule(function()
      -- Skip when opening a specific file (e.g. nvim foo.lua)
      if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) ~= 1 then
        return
      end
      persistence.load()
    end)
  end,
}
