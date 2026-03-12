return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        dependencies = { "leoluz/nvim-dap-go" },
      },
      "sidlatau/neotest-dart",
      "lawrence-laz/neotest-zig",
      {
        "rcasia/neotest-java",
        ft = "java",
        dependencies = {
          "mfussenegger/nvim-jdtls",
          "mfussenegger/nvim-dap", -- for the debugger
        },
      },
      {
        'thenbe/neotest-playwright',
      }
    },
    config = function()
      local current_path = vim.loop.cwd()
      local in_special_repo = current_path:match("projects/myspecialrepo") ~= nil
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({ recursive_run = true }), -- Registration
          -- require :NeotestJava setup
          ["neotest-java"] = {},
          require("neotest-dart")({
            command = "flutter", -- Command being used to run tests. Defaults to `flutter`
            -- Change it to `fvm flutter` if using FVM
            -- change it to `dart` for Dart only tests
            use_lsp = true, -- When set Flutter outline information is used when constructing test name.
            -- Useful when using custom test names with @isTest annotation
            custom_test_method_names = {},
          }),
          -- Registration
          require("neotest-zig")({
            dap = {
              adapter = "lldb",
            },
          }),
          require('neotest-playwright').adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestArguments = function(defaultArguments, context)
              return defaultArguments
            end,
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd() .. '/apps/api'
            end,
            isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
          })
        },
      })

      vim.keymap.set("n", "<Leader>tr", ':lua require("neotest").run.run()<CR>', {})
      -- run with debugging, need debug point
      vim.keymap.set("n", "<Leader>tb", ':lua require("neotest").run.run({strategy = "dap"})<CR>', {})
      -- stop running test
      vim.keymap.set("n", "<Leader>ts", ':lua require("neotest").run.stop()<CR>', {})
      -- open dialog
      vim.keymap.set("n", "<Leader>to", function() require("neotest").output.open({ enter = true }) end, {})
      vim.keymap.set("n", "<Leader>tv", ':lua require("neotest").summary.toggle()<CR>', {})
      -- run all test in file
      vim.keymap.set("n", "<Leader>tp", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', {})
    end,
  },
}
