return {
  "folke/sidekick.nvim",
  keys = {
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
        require("snacks").input({
          prompt = "Sidekick",
          default = "{this}: ",
          icon = "󰚩",
        }, function(user_input)
          if user_input and user_input ~= "" then
            local last_char = user_input:sub(-1)
            local should_submit = not (last_char == " " or last_char == "\t")
            require("sidekick.cli").send({
              msg = user_input,
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
