return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    local harpoon_extensions = require("harpoon.extensions")

    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    harpoon:extend(harpoon_extensions.builtins.navigate_with_number())

    local toggle_opts = {
      border = "rounded",
      title_pos = "center",
      ui_width_ratio = 0.6,
    }

    harpoon:setup()

    local function sync_index_on_select()
        return {
            SELECT = function(data)
                if data.idx then
                    data.list._index = data.idx
                end
            end,
        }
    end
    harpoon:extend(sync_index_on_select())

    local function select_and_sync(idx)
      local list = harpoon:list()
      list:select(idx)
      list._index = idx
    end

    local uv = vim.uv or vim.loop

    local function normalize_path(path)
      if not path or path == "" then
        return nil
      end

      local expanded = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
      return uv.fs_realpath(expanded) or expanded
    end

    local function sync_index_with_current_buffer()
      local current_path = normalize_path(vim.api.nvim_buf_get_name(0))
      if not current_path then
        return
      end

      local list = harpoon:list()
      for idx, item in ipairs(list.items or {}) do
        local item_path = normalize_path(item.value or item.path or item.filename)
        if item_path and item_path == current_path then
          list._index = idx
          return
        end
      end
    end

    local sync_group = vim.api.nvim_create_augroup("HarpoonSyncIndex", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = sync_group,
      callback = sync_index_with_current_buffer,
      desc = "Sync harpoon index to current buffer",
    })

    do
      local stl = vim.o.statusline ~= "" and vim.o.statusline
      local harpoon_part = "%{luaeval(\"require('harpoon_statusline').get()\")}"

      if stl ~= nil and not stl:find("harpoon_statusline", 1, true) then
        local f_start = stl:find("%f", 1, true)
        if f_start then
          local f_end = f_start + 1
          stl = stl:sub(1, f_end) .. harpoon_part .. stl:sub(f_end + 1)
        else
          stl = stl .. harpoon_part
        end
      end

      vim.o.statusline = stl
    end

    vim.keymap.set("n", "<leader>a", function()
      local list = harpoon:list()
      list:add()
      list._index = list:length()
    end, { desc = "Add to harpoon" })
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts) end,
      { desc = "Show harpoon list", remap = false })
    vim.keymap.set("n", "<M-a>", function() select_and_sync(1) end, { desc = "Move to harpoon item 1" })
    vim.keymap.set("n", "<M-s>", function() select_and_sync(2) end, { desc = "Move to harpoon item 2" })
    vim.keymap.set("n", "<M-d>", function() select_and_sync(3) end, { desc = "Move to harpoon item 3" })
    vim.keymap.set("n", "<M-f>", function() select_and_sync(4) end, { desc = "Move to harpoon item 4" })

    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Move to previous harpoon" })
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Move to next harpoon" })
  end
}
