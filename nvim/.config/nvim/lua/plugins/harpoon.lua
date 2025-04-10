return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<Leader>a", function() harpoon:list():add() end, {desc = 'Add to harpoon'})
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<Leader>1", function() harpoon:list():select(1) end, {desc = 'Go to harpoon 1'})
      vim.keymap.set("n", "<Leader>2", function() harpoon:list():select(2) end, {desc = 'Go to harpoon 2'})
      vim.keymap.set("n", "<Leader>3", function() harpoon:list():select(3) end, {desc = 'Go to harpoon 3'})
      vim.keymap.set("n", "<Leader>4", function() harpoon:list():select(4) end, {desc = 'Go to harpoon 4'})
    end,
}
