return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<leader>p", function() require("opencode").ask() end, { desc = "Ask opencode…" })
    vim.keymap.set({ "v", "x" }, "go", function() return require("opencode").operator("@this ") end,
      { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })
  end,
}
