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

    vim.keymap.set("n", "<leader>a", function()
      local list = harpoon:list()
      list:add()
      list._index = list:length()
    end, { desc = "Add to harpoon" })
    vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts) end,
      { desc = "Show harpoon list" })
    vim.keymap.set("n", "<leader>1", function() select_and_sync(1) end, { desc = "Move to harpoon item 1" })
    vim.keymap.set("n", "<leader>2", function() select_and_sync(2) end, { desc = "Move to harpoon item 2" })
    vim.keymap.set("n", "<leader>3", function() select_and_sync(3) end, { desc = "Move to harpoon item 3" })
    vim.keymap.set("n", "<leader>4", function() select_and_sync(4) end, { desc = "Move to harpoon item 4" })
    vim.keymap.set("n", "<leader>5", function() select_and_sync(5) end, { desc = "Move to harpoon item 5" })
    vim.keymap.set("n", "<leader>6", function() select_and_sync(6) end, { desc = "Move to harpoon item 6" })
    vim.keymap.set("n", "<leader>7", function() select_and_sync(7) end, { desc = "Move to harpoon item 7" })
    vim.keymap.set("n", "<leader>8", function() select_and_sync(8) end, { desc = "Move to harpoon item 8" })

    vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end, { desc = "Move to previous harpoon" })
    vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end, { desc = "Move to next harpoon" })
  end
}
