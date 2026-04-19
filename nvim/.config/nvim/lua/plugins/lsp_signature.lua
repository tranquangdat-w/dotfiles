return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  opts = {
    bind = true,
    floating_window = false,
    floating_window_above_cur_line = true,
    toggle_key = "<C-s>",
    toggle_key_flip_floatwin_setting = false,
    always_trigger = false,
    fix_pos = false,
    close_timeout = 1200,
    hi_parameter = "LspSignatureActiveParameter",
    padding = "",
    handler_opts = {
      border = "rounded"
    },
    hint_enable = false,
    hint_prefix = "",
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "#1a1b26", bg = "#7aa2f7", bold = true })
    require("lsp_signature").setup(opts)
  end,
  -- or use config
  -- config = function(_, opts) require'lsp_signature'.setup({you options}) end
}
