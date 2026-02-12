return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "tabs",
        max_name_length = 200,
        modified_icon = "",
        separator_style = "none",
        show_buffer_close_icons = false,
        show_close_icon = false,
        name_formatter = function(buf)
          local path = buf.path or buf.name or ""

          -- Nếu là oil buffer thì loại bỏ prefix "oil://"
          if path:match("^oil://") then
            path = path:gsub("^oil://", "")
          end

          -- Loại bỏ trường hợp oil tự thêm 3 dấu "/" → "oil:///"
          path = path:gsub("^///", "/")

          -- Chuyển thành relative path
          local rel = vim.fn.fnamemodify(path, ":.")

          return rel ~= "" and rel or "[Oil]"
        end,
      },
      highlights = {
        background = { bg = 'none' },
        fill = { bg = 'none' },
        buffer_selected = { bg = 'none', fg = '#fabd2f', bold = true },
        buffer_visible = { bg = 'none', fg = '#a89984' },
        close_button = { bg = 'none' },
        close_button_selected = { bg = 'none' },
        close_button_visible = { bg = 'none' },
        duplicate = { bg = 'none' },
        duplicate_selected = { bg = 'none' },
        duplicate_visible = { bg = 'none' },
        error = { bg = 'none' },
        error_selected = { bg = 'none' },
        error_visible = { bg = 'none' },
        hint = { bg = 'none' },
        hint_selected = { bg = 'none' },
        hint_visible = { bg = 'none' },
        indicator_selected = { bg = 'none' },
        indicator_visible = { bg = 'none' },
        info = { bg = 'none' },
        info_selected = { bg = 'none' },
        info_visible = { bg = 'none' },
        modified = { bg = 'none' },
        modified_selected = { bg = 'none' },
        modified_visible = { bg = 'none' },
        numbers = { bg = 'none' },
        numbers_selected = { bg = 'none' },
        numbers_visible = { bg = 'none' },
        offset_separator = { bg = 'none' },
        pick = { bg = 'none' },
        pick_selected = { bg = 'none' },
        pick_visible = { bg = 'none' },
        separator = { bg = 'none' },
        separator_selected = { bg = 'none' },
        separator_visible = { bg = 'none' },
        tab = { bg = 'none' },
        tab_close = { bg = 'none' },
        tab_selected = { bg = 'none' },
        tab_separator = { bg = 'none' },
        tab_separator_selected = { bg = 'none' },
        trunc_marker = { bg = 'none' },
        warning = { bg = 'none' },
        warning_selected = { bg = 'none' },
        warning_visible = { bg = 'none' },
      }
    })
  end,
}

