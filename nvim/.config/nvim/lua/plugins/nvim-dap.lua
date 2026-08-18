return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    vim.api.nvim_create_augroup("DapGroup", { clear = true })

    local function navigate(args)
      local buffer = args.buf

      local wid = nil
      local win_ids = vim.api.nvim_list_wins()
      for _, win_id in ipairs(win_ids) do
        local win_bufnr = vim.api.nvim_win_get_buf(win_id)
        if win_bufnr == buffer then
          wid = win_id
        end
      end

      if wid == nil then
        return
      end

      vim.schedule(function()
        if vim.api.nvim_win_is_valid(wid) then
          vim.api.nvim_set_current_win(wid)
        end
      end)
    end

    local function create_nav_options(name)
      return {
        group = "DapGroup",
        pattern = string.format("*%s*", name),
        callback = navigate,
      }
    end

    local dap = require("dap")
    local dapui = require("dapui")

    vim.fn.sign_define("DapBreakpoint",
      { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",
      { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected",
      { text = "", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint",
      { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped",
      { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual", numhl = "DiagnosticSignWarn" })

    local function layout(name)
      return {
        elements = {
          { id = name },
        },
        enter = true,
        size = 50,
        position = "right",
      }
    end

    local name_to_layout = {
      repl = { layout = layout("repl"), index = 0 },
      stacks = { layout = layout("stacks"), index = 0 },
      scopes = { layout = layout("scopes"), index = 0 },
      console = { layout = layout("console"), index = 0 },
      watches = { layout = layout("watches"), index = 0 },
      breakpoints = { layout = layout("breakpoints"), index = 0 },
    }
    local layouts = {}

    for name, config in pairs(name_to_layout) do
      table.insert(layouts, config.layout)
      name_to_layout[name].index = #layouts
    end

    local DEFAULT_PANEL_SIZE = 40

    -- open one element at its normal size, without toggling it shut again
    local function open_debug_ui(name)
      local layout_config = name_to_layout[name]

      if layout_config == nil then
        error(string.format("bad name: %s", name))
      end

      dapui.close()
      layout_config.layout.size = DEFAULT_PANEL_SIZE
      pcall(dapui.open, layout_config.index)
    end

    local function toggle_debug_ui(name)
      dapui.close()
      local layout_config = name_to_layout[name]

      if layout_config == nil then
        error(string.format("bad name: %s", name))
      end

      local uis = vim.api.nvim_list_uis()[1]
      if uis ~= nil then
        layout_config.layout.size = uis.width
      end

      pcall(dapui.toggle, layout_config.index)
    end

    vim.keymap.set("n", "<leader>dr", function() toggle_debug_ui("repl") end, { desc = "Debug: toggle repl ui" })
    vim.keymap.set("n", "<leader>dS", function() toggle_debug_ui("stacks") end, { desc = "Debug: toggle stacks ui" })
    vim.keymap.set("n", "<leader>dw", function() toggle_debug_ui("watches") end, { desc = "Debug: toggle watches ui" })
    vim.keymap.set("n", "<leader>dp", function() toggle_debug_ui("breakpoints") end,
      { desc = "Debug: toggle breakpoints ui" })
    vim.keymap.set("n", "<leader>ds", function() toggle_debug_ui("scopes") end, { desc = "Debug: toggle scopes ui" })
    vim.keymap.set("n", "<leader>dc", function() toggle_debug_ui("console") end, { desc = "Debug: toggle console ui" })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = "DapGroup",
      pattern = "*dap-repl*",
      callback = function()
        vim.wo.wrap = true
      end,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
    vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

    dapui.setup({
      layouts = layouts,
      enter = true,
      icons = { expanded = "", collapsed = "", current_frame = "" },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
          disconnect = "",
        },
      },
    })

    require("dap-go").setup()
    require("dap-python").setup("uv")

    -- CHECK
    local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_debug_path, "${port}" }
      }
    }

    for _, language in ipairs({
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "svelte", }) do
      dap.configurations[language] = {
        -- attach to a node process that has been started with
        -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
        -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
        {
          -- use nvim-dap-vscode-js's pwa-node debug adapter
          type = "pwa-node",
          -- attach to an already running node process with --inspect flag
          -- default port: 9222
          request = "attach",
          -- allows us to pick the process using a picker
          processId = require 'dap.utils'.pick_process,
          -- name of the debug action you have to select for this config
          name = "Attach debugger to existing `node --inspect` process",
          -- for compiled languages like TypeScript or Svelte.js
          sourceMaps = true,
          -- resolve source maps in nested locations while ignoring node_modules
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**" },
          -- path to src in vite based projects (and most other projects as well)
          cwd = "${workspaceFolder}/src",
          -- we don't want to debug code inside node_modules, so skip it!
          skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
        },
        {
          name = 'Next.js: debug server-side',
          type = 'pwa-node',
          request = 'attach',
          port = 9231,
          skipFiles = { 'node_modules/**' },
          cwd = '${workspaceFolder}',
        },

        -- {
        --   type = "pwa-chrome",
        --   name = "Launch Chrome to debug client",
        --   request = "launch",
        --   url = "http://localhost:5173",
        --   sourceMaps = true,
        --   protocol = "inspector",
        --   port = 9222,
        --   webRoot = "${workspaceFolder}/src",
        --   -- skip files from vite's hmr
        --   skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
        -- },

        -- only if language is javascript, offer this debug action
        {
          -- use nvim-dap-vscode-js's pwa-node debug adapter
          type = "pwa-node",
          -- launch a new process to attach the debugger to
          request = "launch",
          -- name of the debug action you have to select for this config
          name = "Launch file in new node process",
          -- launch current file
          program = "${file}",
          cwd = "${workspaceFolder}",
        } or nil,
      }
    end

    -- auto-open the repl once the adapter is ready
    dap.listeners.after.event_initialized.dapui_config = function()
      open_debug_ui("repl")
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    dap.listeners.after.event_output.dapui_config = function(_, body)
      if body.category == "console" then
        dapui.eval(body.output) -- Sends stdout/stderr to Console
      end
    end

    vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debug: Continue" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
    vim.keymap.set("n", "<F4>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F5>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local line = vim.api.nvim_win_get_cursor(0)[1]
      local existing = require("dap.breakpoints").get(bufnr)[bufnr] or {}

      for _, bp in ipairs(existing) do
        if bp.line == line then
          dap.toggle_breakpoint()
          return
        end
      end

      vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
        if condition and condition ~= "" then
          dap.set_breakpoint(condition)
        end
      end)
    end, { desc = "Debug: Toggle Conditional Breakpoint" })
  end
}

-- dont for get to install debugger here: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- eg: go... brew install delve, then add go dependencies
