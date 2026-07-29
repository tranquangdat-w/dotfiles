return {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },

    keys = {
        {
            "<leader>kt",
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
            timeout = 0, -- disable subprocess timeout
        },
        global_keymaps = false,
        global_keymaps_prefix = "<leader>k",
        kulala_keymaps_prefix = "",
    },
}
