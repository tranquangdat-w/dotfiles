return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/aerial.nvim",
    },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        winopts = {
          preview = {
            -- layout = "vertical",
            horizontal = "right:45%",
          },
        },
        fzf_colors = {
          true,
          bg = "-1",
          gutter = "-1",
        },
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        }
      })

      local aerial = require("aerial")
      aerial.setup({
        layout = {
          min_width = 30,
          default_direction = "left",
        },
        keymaps = {
          -- Send the HTTP request under the cursor via kulala, without leaving the Aerial window
          ["<C-s>"] = {
            callback = function()
              local util = require("aerial.util")
              local src_buf = util.get_source_buffer()
              if not src_buf or not vim.tbl_contains({ "http", "rest" }, vim.bo[src_buf].filetype) then
                return
              end
              -- Move the source window's cursor to the request line (keeps focus in Aerial)
              require("aerial").select({ jump = false })
              -- Find the window showing the source buffer and run kulala in its context
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_buf(win) == src_buf then
                  vim.api.nvim_win_call(win, function()
                    require("kulala").run()
                  end)
                  break
                end
              end
            end,
            desc = "Send HTTP request under cursor (kulala)",
          },
        },
      })

      local harpoon = require('harpoon')
      harpoon:setup({})

      -- Shared scope state across all pickers: ctrl-o in any picker toggles
      -- all pickers together. Persists between invocations (not reset on open).
      local scoped = false

      -- Wraps a fzf-lua picker with a ctrl-o action that toggles cwd
      -- between global and current dir (oil dir or current buffer's dir).
      -- Query only carries over across the ctrl-o toggle itself; a fresh
      -- invocation of the keymap always starts with an empty query.
      -- query_field is "search" for live_grep-style pickers, "query" otherwise.
      local function make_scoped_picker(picker, build_opts, query_field)
        query_field = query_field or "query"
        local run
        run = function(preserve_query)
          local query = preserve_query and fzf.get_last_query() or nil
          local cwd = nil
          if scoped then
            cwd = vim.bo.filetype == "oil" and require("oil").get_current_dir() or vim.fn.expand("%:p:h")
          end
          local opts = build_opts(cwd)
          opts[query_field] = query
          opts.actions = opts.actions or {}
          opts.actions["ctrl-o"] = function()
            scoped = not scoped
            run(true)
          end
          picker(opts)
        end
        return function() run(false) end
      end

      local find_dirs = make_scoped_picker(fzf.files, function(cwd)
        return {
          cwd = cwd,
          fd_opts = "--type d --hidden --exclude .git",
          previewer = false,
          actions = {
            ["default"] = function(selected, opts)
              if not selected or not selected[1] then
                return
              end

              local entry = require("fzf-lua.path").entry_to_file(selected[1], opts)
              vim.cmd("Oil " .. vim.fn.fnameescape(entry.path))
            end,
          },
        }
      end)
      vim.keymap.set("n", "<BS>l", find_dirs, { desc = "Find Directories (ctrl-o: toggle dir scope)" })

      vim.keymap.set("n", "<BS>m", function() require("aerial").fzf_lua_picker({}) end,
        { desc = "Open Aerial (functions only)" })

      vim.keymap.set("n", "<leader>m", ":AerialToggle<CR>")

      -- Jump to next/previous function (symbol) using Aerial
      vim.keymap.set("n", "]f", "<cmd>AerialNext<CR>", { desc = "Next function/symbol" })
      vim.keymap.set("n", "[f", "<cmd>AerialPrev<CR>", { desc = "Prev function/symbol" })

      -- Tùy chỉnh màu số dòng trong grep
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { bg = "#1e1e1e", bold = true })

      local find_files = make_scoped_picker(fzf.files, function(cwd)
        return {
          cwd = cwd,
          fd_opts =
          "--type f --hidden --exclude '*.class' --exclude 'app/bin' --exclude 'node_modules' --exclude '.git' --exclude .gradle --exclude .settings --exclude 'build' --exclude '.next'",
          previewer = false,
        }
      end)
      vim.keymap.set("n", "<BS>f", find_files, { desc = "Find Files (ctrl-o: toggle dir scope)" })
      vim.keymap.set("n", "<BS>g", fzf.git_status, { desc = "Find Git status Files" })

      local live_grep = make_scoped_picker(fzf.live_grep, function(cwd)
        return { cwd = cwd }
      end, "search")
      vim.keymap.set("n", "<BS>;", live_grep, { desc = "Live Grep (ctrl-o: toggle dir scope)" })
      vim.keymap.set("n", "<BS>'", fzf.marks, { desc = "Find marks" })

      local live_grep_hidden = make_scoped_picker(fzf.live_grep, function(cwd)
        return {
          cwd = cwd,
          rg_opts =
          "--hidden --no-ignore --glob=!.git/* --glob=!**/node_modules/* --column --line-number --no-heading --color=always --smart-case -e",
        }
      end, "search")
      vim.keymap.set("n", "<BS>.", live_grep_hidden, { desc = "Live Grep includes hidden files (ctrl-o: toggle dir scope)" })
      vim.keymap.set("n", "<BS>,", function()
        fzf.buffers({
          previewer = false
        })
      end, { desc = "Buffers" })
      vim.keymap.set("n", "<BS>/", fzf.grep_curbuf, { desc = "Grep in Current Buffer" })
      vim.keymap.set("n", "<BS>r", fzf.resume, { desc = "Resume fzf serach" })
      vim.keymap.set("n", "<BS>q", fzf.quickfix_stack, { desc = "Open quickfix history" })
      vim.keymap.set("n", "<BS>e", fzf.diagnostics_document, { desc = "Diagnostics (buffer)" })
      vim.keymap.set("n", "<BS>E", fzf.diagnostics_workspace, { desc = "Diagnostics (workspace)" })
      vim.keymap.set("n", "<BS>w", function()
        require("fzf-lua").grep_cword({ rg_opts = "--word-regexp" })
      end)
      vim.keymap.set('n', '<BS>c', function()
        require('gitsigns').setqflist(0)
      end, { desc = "Git hunks (Quickfix)" })

      vim.keymap.set("n", "<BS>b", function()
        require("fzf-lua").git_branches({
          prompt = "Branches> ",
          preview = "git log --oneline --graph --decorate -20 {1}",
        })
      end, { desc = "Git branches (fzf)" })

      vim.keymap.set("n", "<BS>W", function()
        require("fzf-lua").git_worktrees()
      end, { desc = "Git worktrees (fzf)" })
    end,
  },
}
