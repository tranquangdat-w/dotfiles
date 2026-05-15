return {
  "chentoast/marks.nvim",
  event = "VeryLazy",

  opts = {},

  keys = {
    { "<leader>`", "<cmd>MarksQFListAll<cr>", desc = "Open quickfix all marks" },
  },

  config = function(_, opts)
    require("marks").setup(opts)

    local function set_mark(mark)
      local pos = vim.api.nvim_buf_get_mark(0, mark)

      if pos[1] ~= 0 then
        vim.api.nvim_echo({
          {
            ("Overwrite mark '%s' at line %d? [y/N]: ")
              :format(mark, pos[1]),
            "Question",
          },
        }, false, {})

        local char = vim.fn.nr2char(vim.fn.getchar())

        vim.cmd("echo ''")

        if char:lower() ~= "y" then
          return
        end
      end

      vim.cmd("normal! m" .. mark)
    end

    for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):gmatch(".") do
      vim.keymap.set("n", "m" .. c, function()
        set_mark(c)
      end, {
        silent = true,
        desc = "Set mark with confirmation",
      })
    end
  end,
}
