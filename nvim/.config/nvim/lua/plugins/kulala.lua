return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },

  keys = {
    {
      "<C-s>",
      function()
        require("kulala").run()
      end,
      desc = "Send request",
    },
    {
      "<leader>ka",
      function()
        require("kulala").run_all()
      end,
      desc = "Send all requests",
    },
    {
      "<leader>ko",
      function()
        require("kulala").scratchpad()
      end,
      desc = "Open scratchpad",
    },
    {
      "<leader>ke",
      function()
        require("kulala").set_selected_env()
      end,
      desc = "Select env",
    },
  },

  opts = {
    kulala_core = {
      timeout = 0,       -- disable subprocess timeout
    },
    kulala_keymaps = {
      -- Chuyển tab response bằng { và } thay vì Ctrl+h / Ctrl+l
      ["Previous tab"] = {
        "{",
        function() require("kulala.ui").show_previous_tab() end,
        mode = { "n" },
      },
      ["Next tab"] = {
        "}",
        function() require("kulala.ui").show_next_tab() end,
        mode = { "n" },
      },
      -- Bỏ phím V (mặc định của kulala), chuyển "Show verbose" sang E
      ["Show verbose"] = {
        "E",
        function() require("kulala.ui").show_verbose() end,
      },
    },
    global_keymaps = false,
    global_keymaps_prefix = "<leader>k",
    kulala_keymaps_prefix = "",
  },
}
