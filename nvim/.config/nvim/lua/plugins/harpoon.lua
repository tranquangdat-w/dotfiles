return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add to harpoon"})
    vim.keymap.set("n", "<leader>ha", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc= "Show harpoon list" })

    vim.keymap.set("n", "<leader>ho", function()
      for _, item in ipairs(require("harpoon"):list().items) do
        vim.cmd("edit " .. item.value)
      end

    end, { desc = "Open all harpoon files" })

    vim.keymap.set("n", "<leader>hc", function()
      local harpoon_paths = {}

      -- Lưu Harpoon paths dưới dạng đường dẫn tuyệt đối
      for _, item in ipairs(harpoon:list().items) do
        local abs_path = vim.fn.fnamemodify(item.value, ":p") -- :p = full path
        harpoon_paths[abs_path] = true
      end

      -- Đóng buffer không nằm trong Harpoon list
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
          local buf_path = vim.api.nvim_buf_get_name(buf)
          if buf_path ~= "" and not harpoon_paths[buf_path] then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
    end, { desc = "Close buffers not in Harpoon list" })
  end
}
