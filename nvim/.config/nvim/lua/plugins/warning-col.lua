return {
  "lukas-reineke/virt-column.nvim",
  event = "BufReadPost",
  opts = {
    char = { "┃" },
    highlight = { "VirtColumnGray" },
  },
  config = function()
    -- Highlight màu xám cho cột
    vim.cmd([[highlight VirtColumnGray guifg=#666666 gui=nocombine]])

    -- Bảng quy định số cột theo filetype
    local filetype_columns = {
      java = "94",
      javascript = "94",
      javascriptreact = "94",
      typescript = "94",
      typescriptreact = "94",
      python = "79",
      go = "94",
    }

    -- Autocmd đổi colorcolumn theo filetype
    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.tbl_keys(filetype_columns),
      callback = function(args)
        local col = filetype_columns[args.match]
        vim.opt_local.colorcolumn = col
      end,
    })
  end,
}

