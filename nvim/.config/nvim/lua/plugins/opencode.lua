return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  -- dependencies = {
  --   {
  --     "folke/snacks.nvim",
  --     opts = {
  --       input = { enabled = true },
  --       styles = {
  --         input = {
  --           relative = "cursor",
  --           width = 40,
  --           row = -3,
  --           keys = {
  --             i_ctrl_j = "<C-n>",
  --             i_ctrl_k = "<C-p>",
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  config = function()
    vim.o.autoread = true
    vim.keymap.set({ "n", "x" }, "<leader>o", function() require("opencode").ask("@this: ", { submit = false }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<leader>O", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
  end,
}
