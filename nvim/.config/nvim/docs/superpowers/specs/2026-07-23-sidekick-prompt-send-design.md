# Design Spec: Sidekick Prompt Send Keymaps

## Overview
Update `sidekick.lua` keymaps (`3t`, `3f`, `3v`, `3o`) to use an interactive `snacks.input` prompt pre-filled with context tags (`{this}`, `{file}`, `{selection}`). Input ending with trailing whitespace will paste without submitting, while input without trailing whitespace will submit automatically.

## Key Changes
1. Extract helper function `prompt_send(default_text)` in `lua/plugins/sidekick.lua`.
2. Update keybindings:
   - `3t`: `prompt_send("{this} ")`
   - `3f`: `prompt_send("{file} ")`
   - `3v`: `prompt_send("{selection}")`
   - `3o`: `prompt_send("{this}: ")`
3. Function behavior:
   - Evaluates `last_char == " " or last_char == "\t"` to set `should_submit`.
   - Calls `context:render({ msg = user_input })`.
   - Calls `cli.send({ text = text, submit = should_submit })`.

## Verification
- Load Neovim configuration and verify `3t`, `3f`, `3v`, `3o` keymaps open `snacks.input` with correct pre-filled default strings and behave as expected on submit.
