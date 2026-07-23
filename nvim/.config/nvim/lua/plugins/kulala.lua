return {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },

    keys = {
        {
            "<leader>Kt",
            function()
                require("kulala").run()
            end,
            desc = "Send request",
        },
        {
            "<leader>Ka",
            function()
                require("kulala").run_all()
            end,
            desc = "Send all requests",
        },
        {
            "<leader>Ko",
            function()
                require("kulala").scratchpad()
            end,
            desc = "Open scratchpad",
        },
        {
            "<leader>Ke",
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
        global_keymaps_prefix = "<leader>K",
        kulala_keymaps_prefix = "",
    },
}
