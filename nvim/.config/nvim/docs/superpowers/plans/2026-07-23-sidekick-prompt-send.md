# Sidekick Prompt Send Keymaps Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update `3t`, `3f`, `3v`, and `3o` keybindings in `sidekick.lua` to open `snacks.input` pre-filled with context tags (`{this} `, `{file} `, `{selection}`, `{this}: `) and automatically determine whether to submit or append to the CLI session based on trailing whitespace.

**Architecture:** Define a reusable local function `prompt_send(default_text)` in `lua/plugins/sidekick.lua` that invokes `snacks.input`, renders context using `sidekick.cli.context`, and dispatches `cli.send({ text = text, submit = should_submit })`.

**Tech Stack:** Lua, Neovim, `folke/sidekick.nvim`, `folke/snacks.nvim`.

## Global Constraints
- Target file: `lua/plugins/sidekick.lua`
- Preserve existing keymap shortcuts and modes (`3t`, `3f`, `3v`, `3o`).

---

### Task 1: Refactor `sidekick.lua` keymaps to use `prompt_send`

**Files:**
- Modify: `lua/plugins/sidekick.lua:80-135`

**Interfaces:**
- Consumes: `snacks.input`, `sidekick.cli`, `sidekick.cli.context`
- Produces: `prompt_send(default_text)` helper function and updated `keys` list.

- [ ] **Step 1: Inspect `lua/plugins/sidekick.lua` key bindings**

Run: `git status`
Expected: Working tree clean (or only docs committed).

- [ ] **Step 2: Update `lua/plugins/sidekick.lua`**

Replace lines 81-135 with:

```lua
    {
      "3t",
      function() prompt_send("{this} ") end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "3f",
      function() prompt_send("{file} ") end,
      desc = "Send File",
    },
    {
      "3v",
      function() prompt_send("{selection}") end,
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
      function() prompt_send("{this}: ") end,
      mode = { "n", "x" },
      desc = "Sidekick: Custom prompt (space at end to append)",
    },
```

And place the `prompt_send` helper function right above the `return` table or inside `sidekick.lua`:

```lua
local function prompt_send(default_text)
  local cli = require("sidekick.cli")
  local context = require("sidekick.cli.context").get()

  require("snacks").input({
    prompt = "Sidekick",
    default = default_text,
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
end
```

- [ ] **Step 3: Test Lua syntax**

Run: `luac -p lua/plugins/sidekick.lua` or `nvim --headless -c "luafile lua/plugins/sidekick.lua" -c "q"`
Expected: No syntax errors.

- [ ] **Step 4: Commit changes**

```bash
git add lua/plugins/sidekick.lua
git commit -m "feat(sidekick): support prompt send for 3t, 3f, 3v keymaps"
```
