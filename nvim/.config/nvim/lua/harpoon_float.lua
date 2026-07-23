local M = {}
local win, buf

local function should_hide()
  -- Command-line window
  if vim.fn.getcmdwintype() ~= "" then
    return true
  end

  local bt = vim.bo.buftype
  local ft = vim.bo.filetype

  -- Quickfix & Location List
  if bt == "quickfix" then
    return true
  end

  -- Optional: hide in special buffers
  if ft == "qf" then
    return true
  end

  -- Hide when cursor is on the last visible line
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local last_visible = vim.fn.line("w$")

  if cursor == last_visible then
    return true
  end

  return false
end

local function get_display_name(path)
  if not path or path == "" then return "" end
  local is_dir = path:match("^oil://") ~= nil or path:sub(-1) == "/"
  local clean = path:gsub("^oil://", ""):gsub("/+$", "")
  if clean == "" then return path end

  if not is_dir then
    local uv = vim.uv or vim.loop
    local o, exp = pcall(vim.fn.expand, clean)
    local full = o and exp or clean
    local stat = uv.fs_stat(full)
    if stat and stat.type == "directory" then
      is_dir = true
    end
  end

  local tail = vim.fn.fnamemodify(clean, ":t")
  local name = (tail ~= "" and tail) or clean
  return is_dir and (name .. "/") or name
end

local function get_info()
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then return end
  local items = harpoon:list().items or {}
  if #items == 0 then return end

  local cur = vim.api.nvim_buf_get_name(0)
  local function norm(p)
    if not p or p == "" then return end
    local clean = p:gsub("^oil://", ""):gsub("/+$", "")
    if clean == "" then clean = "/" end
    local o, exp = pcall(vim.fn.expand, clean)
    exp = vim.fn.fnamemodify(o and exp or clean, ":p"):gsub("/+$", "")
    return (vim.uv or vim.loop).fs_realpath(exp) or exp
  end

  local norm_cur, idx = norm(cur), nil
  for i, item in ipairs(items) do
    if norm(item.value or item.path or item.filename) == norm_cur then
      idx = i; break
    end
  end
  return { items = items, current = idx }
end

local function render()
  if not win or not vim.api.nvim_win_is_valid(win) then return end
  local info = get_info()
  if not info then return M.hide() end

  local segs, hls, col = {}, {}, 0
  for i, item in ipairs(info.items) do
    local name = get_display_name(item.value or item.path or item.filename)
    local seg = i .. ":" .. name .. "  "
    table.insert(segs, seg)
    table.insert(hls, { col, col + #seg - 2, i == info.current and "HarpoonCurrent" or "HarpoonInactive" })
    col = col + #seg
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { table.concat(segs) })
  vim.bo[buf].modifiable = false

  local ns = vim.api.nvim_create_namespace("hp_float")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for _, r in ipairs(hls) do vim.api.nvim_buf_set_extmark(buf, ns, 0, r[1], { end_col = r[2], hl_group = r[3] }) end
end

function M.show()
  if not get_info() then return end
  if should_hide() then
    return
  end
  M.hide()
  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype, vim.bo[buf].bufhidden = "nofile", "wipe"

  win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = vim.o.columns,
    height = 1,
    style = "minimal",
    border = "none",
    row = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus >= 1 and 1 or 0) - 1,
    col = 0,
    focusable = false,
    zindex = 45,
  })
  vim.wo[win].winhighlight = "Normal:HarpoonFloatNormal"
  render()
end

function M.hide()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true); win = nil
  end
end

function M.toggle() if win and vim.api.nvim_win_is_valid(win) then M.hide() else M.show() end end

function M.refresh()
  if should_hide() then
    M.hide()
    return
  end
  if not win or not vim.api.nvim_win_is_valid(win) then return M.show() end
  vim.api.nvim_win_set_config(win, {
    relative = "editor",
    width = vim.o.columns,
    row = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus >= 1 and 1 or 0) - 1,
    col = 0,
  })
  render()
end

local function define_highlights()
  vim.api.nvim_set_hl(0, "HarpoonCurrent", { link = "Normal", bold = true, italic = false })

  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
  vim.api.nvim_set_hl(0, "HarpoonInactive", {
    fg = comment_hl.fg,
    bg = comment_hl.bg,
    italic = false,
    bold = false,
  })

  vim.api.nvim_set_hl(0, "HarpoonFloatNormal", { link = "Normal" })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("HarpoonFloat", { clear = true })
  define_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = define_highlights,
  })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "VimResized", "User" }, {
    group = group,
    pattern = { "*", "HarpoonAdd", "HarpoonUpdate" },
    callback = function() vim.schedule(M.refresh) end,
  })
  vim.keymap.set("n", "<leader>h", M.toggle, { desc = "Harpoon float toggle" })
  M.show()
end

return M
