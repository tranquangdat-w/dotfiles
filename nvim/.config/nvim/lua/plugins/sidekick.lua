return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  opts = {
    nes = { enabled = false },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
        create = "split",
      },
      tools = {
        kilo = {
          cmd = { "kilo" },
          is_proc = "\\<kilo\\>",
        },
      },
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)

    local has_cmp, cmp = pcall(require, "cmp")
    if has_cmp then
      local items = { "{buffers}", "{file}", "{position}", "{line}", "{selection}", "{diagnostics}", "{diagnostics_all}",
        "{quickfix}", "{function}", "{class}", "{this}" }
      cmp.register_source("sidekick_context", {
        get_keyword_pattern = function() return [[\%({[^{}]*\)]] end,
        get_trigger_characters = function() return { "{" } end,
        complete = function(_, params, callback)
          local line, col = params.context.cursor_line, params.context.cursor.col
          local start = line:sub(1, col - 1):find("{[^}]*$")
          if not start then return callback() end
          callback({
            items = vim.tbl_map(function(item)
              return {
                label = item,
                textEdit = {
                  newText = item,
                  range = {
                    start = { line = params.context.cursor.line, character = start - 1 },
                    ["end"] = { line = params.context.cursor.line, character = line:sub(col, col) == "}" and col or col - 1 },
                  }
                }
              }
            end, items)
          })
        end,
      })
      cmp.setup.filetype("snacks_input", { sources = { { name = "sidekick_context" }, { name = "buffer" } } })
    end
  end,
  keys = {
    {
      "3a",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "3f",
      function() require("sidekick.cli").focus() end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "3s",
      function() require("sidekick.cli").select() end,
      desc = "Select CLI",
    },
    {
      "3d",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "3t",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "3f",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "3v",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "3p",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "3o",
      function()
        local cli = require("sidekick.cli")
        local context = require("sidekick.cli.context").get()

        require("snacks").input({
          prompt = "Sidekick",
          default = "{this}: ",
          icon = "󰚩",
          win = { title_pos = "left", width = 40 }
        }, function(user_input)
          if user_input and user_input ~= "" then
            local last_char = user_input:sub(-1)
            local should_submit = not (last_char == " " or last_char == "\t")

            local _, text = context:render({ msg = user_input })
            if not text then
              return
            end

            cli.send({
              text = text,
              submit = should_submit,
            })
          end
        end)
      end,
      mode = { "n", "x" },
      desc = "Sidekick: Custom prompt (space at end to append)",
    },
  },
}
