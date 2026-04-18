local M = {}

function M.get()
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return ""
  end

  local list = harpoon:list()
  local total = list:length()
  if total == 0 then
    return ""
  end

  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return ""
  end

  local rel = require("plenary.path"):new(name):make_relative(list.config.get_root_dir())
  local _, current_idx = list:get_by_value(rel)
  if not current_idx then
    return ""
  end

  return string.format(" [󰀱 %d/%d]", current_idx, total)
end

return M
