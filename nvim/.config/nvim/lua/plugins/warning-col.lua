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
  end,
}

