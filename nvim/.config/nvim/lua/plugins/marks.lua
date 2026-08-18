return {
  "chentoast/marks.nvim",
  event = "VeryLazy",

  opts = {},

  keys = {
    { "<leader>''", "<cmd>MarksQFListAll<cr>", desc = "QF: list all marks" },
    { "<leader>'b", "<cmd>MarksQFListBuf<cr>", desc = "QF: list buffer marks" },
    { "<leader>'g", "<cmd>MarksQFListGlobal<cr>", desc = "QF: list global marks" },
  },

  config = function(_, opts)
    require("marks").setup(opts)

    -- marks.nvim's own preview only lets you blind-guess a letter with no
    -- indication of which marks exist or a live look at their content.
    -- fzf-lua's marks picker already lists only set marks and shows a live
    -- preview while browsing; override its accept action so picking one
    -- opens a real (editable) float instead of just jumping in-place.
    require("marks.mark").preview_mark = function()
      require("fzf-lua").marks({
        winopts = { height = 0.9, width = 0.9, preview = { horizontal = "right:60%" } },
        actions = {
          ["default"] = function(selected)
            if not selected[1] then return end
            local mark = assert(selected[1]:match("[^ ]+"))
            local pos = vim.fn.getpos("'" .. mark)
            if pos[2] == 0 then return end

            local width = vim.api.nvim_win_get_width(0)
            local height = vim.api.nvim_win_get_height(0)
            local win_width = math.floor(width * 0.9)
            local win_height = math.floor(height * 0.8)

            vim.api.nvim_open_win(pos[1], true, {
              relative = "win",
              win = 0,
              width = win_width,
              height = win_height,
              col = math.floor((width - win_width) / 2),
              row = math.floor((height - win_height) / 2),
              border = "single",
            })
            vim.cmd("normal! `" .. mark)
            vim.cmd("normal! zz")
          end,
        },
      })
    end

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

    -- marks.nvim's "m," only auto-picks the next free lowercase mark;
    -- it has no equivalent for global (A-Z) marks, so add one here.
    local function set_next_global()
      for byte = string.byte("A"), string.byte("Z") do
        local letter = string.char(byte)
        if vim.fn.getpos("'" .. letter)[2] == 0 then
          vim.cmd("normal! m" .. letter)
          require("marks").refresh(true)
          vim.api.nvim_echo({ { "Set global mark " .. letter, "None" } }, false, {})
          return
        end
      end
      vim.api.nvim_echo({ { "No available global mark (A-Z all used)", "WarningMsg" } }, false, {})
    end

    vim.keymap.set("n", "m.", set_next_global, {
      silent = true,
      desc = "Set next available global mark",
    })

    vim.keymap.set("n", "dm.", function()
      vim.cmd("delmarks A-Z")
      require("marks").refresh(true)
      vim.api.nvim_echo({ { "Deleted all global marks (A-Z)", "None" } }, false, {})
    end, {
      silent = true,
      desc = "Delete all global marks",
    })
  end,
}
