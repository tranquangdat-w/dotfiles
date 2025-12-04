return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'leoluz/nvim-dap-go',
    -- 'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local widgets = require('dap.ui.widgets')

    dapui.setup()
    require("dap-go").setup()
    -- require("dap-python").setup("uv")

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
      require("dap").configurations[language] = {
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

    require("dapui").setup({
      layouts = {
        {
          elements = {
            { id = "stacks",      size = 0.10 },
            { id = "breakpoints", size = 0.20 },
            { id = "scopes",      size = 0.25 },
            { id = "watches",     size = 0.45 },
          },
          size = 60,
          position = "left",
        },
        {
          elements = { "repl", "console" },
          size = 20,
          position = "bottom",
        },
      },
    })
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = "Start/Continue Debugging" })
    vim.keymap.set('n', '<leader>de', function() require("dapui").eval(nil, { enter = true }) end, { noremap = true, silent = true, desc = "DAP Eval (focus window)" })
    vim.keymap.set('v', '<leader>de', function() require("dapui").eval(nil, { enter = true }) end, { noremap = true, silent = true, desc = "DAP Eval (focus window)" })
    vim.keymap.set('n', '<leader>ds', function() widgets.hover(nil, { border = "rounded" }) end, { desc = "Show Variable (Hover)" })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = "Step Into Function" })
    vim.keymap.set('n', '<leader>do', dap.step_out, { desc = "Step Out of Function" })

    vim.keymap.set("n", "<leader>dw", function()
      local word = vim.fn.expand("<cword>")
      if word ~= "" then
        dapui.elements.watches.add(word)
        print("Added to watch: " .. word)
      end
    end, { desc = "Add word under cursor to Watch" })

    local function get_visual_selection()
      local _, ls, cs, _ = unpack(vim.fn.getpos("'<"))
      local _, le, ce, _ = unpack(vim.fn.getpos("'>"))

      -- Normalize (swap if reversed)
      if (ls > le) or (ls == le and cs > ce) then
        ls, le = le, ls
        cs, ce = ce, cs
      end

      local lines = vim.fn.getline(ls, le)
      if #lines == 0 then
        return ""
      end

      -- Trim last line
      lines[#lines] = string.sub(
        lines[#lines],
        1,
        ce - (vim.o.selection == "inclusive" and 0 or 1)
      )

      -- Trim first line
      lines[1] = string.sub(lines[1], cs)

      return table.concat(lines, "\n")
    end

    vim.keymap.set("v", "<leader>dw", function()
      local text = get_visual_selection()
      if text ~= "" then
        require("dapui").elements.watches.add(text)
        print("Added to watch: " .. text)
      end
    end, { desc = "Add visual selection to Watch" })
  end
}

-- dont for get to install debugger here: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- eg: go... brew install delve, then add go dependencies
