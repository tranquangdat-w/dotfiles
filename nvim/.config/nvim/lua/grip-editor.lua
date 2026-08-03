-- Enum/boolean cells get a dropdown picker instead of a free-text editor.
--
-- Wraps dadbod-grip's editor.open rather than session.on_edit: the plugin
-- rebuilds the session table on every render (view.lua `M._sessions[bufnr] = {`),
-- so a session-level hook is silently dropped on the next refresh. The editor
-- module is required once per module and shared, so patching the field sticks.
local M = {}

local type_cache, val_cache = {}, {}
local wrapped = false

local function norm(v)
  v = tostring(v or ""):lower()
  if v == "t" or v == "1" or v == "yes" then return "true" end
  if v == "f" or v == "0" or v == "no" then return "false" end
  return v
end

-- Authoritative value list from the catalog: booleans and postgres enums.
-- Beats the plugin's SELECT DISTINCT because labels never used in the table
-- still show up.
local function catalog_values(tbl, col, url)
  local key = url .. "|" .. tbl .. "|" .. col
  if val_cache[key] ~= nil then return val_cache[key] or nil end

  local ok, db = pcall(require, "dadbod-grip.db")
  if not ok then return nil end

  local tkey = url .. "|" .. tbl
  if not type_cache[tkey] then
    local map, cols = {}, db.get_column_info(tbl, url)
    for _, c in ipairs(cols or {}) do map[c.column_name] = c.data_type end
    type_cache[tkey] = cols and map or nil
  end
  if not type_cache[tkey] then return nil end

  local dt = (type_cache[tkey][col] or ""):lower()
  local values
  if dt == "boolean" or dt == "bool" then
    values = { "true", "false" }
  elseif dt:match("^enum%(") then
    -- MySQL spells the type out in the DDL: enum('draft','printed')
    values = {}
    for v in dt:gmatch("'([^']*)'") do values[#values + 1] = v end
    if #values == 0 then values = nil end
  elseif dt == "user-defined" then
    local sql = ([[
SELECT e.enumlabel FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN information_schema.columns c ON c.udt_name = t.typname
WHERE c.table_name = '%s' AND c.column_name = '%s'
ORDER BY e.enumsortorder]]):format(tbl:match("([^.]+)$") or tbl, col)
    local res = db.query(sql, url)
    if res and res.rows then
      values = {}
      for _, r in ipairs(res.rows) do
        if r[1] then values[#values + 1] = tostring(r[1]) end
      end
      if #values == 0 then values = nil end
    end
  end

  val_cache[key] = values or false
  return values
end

-- Values to offer for this edit: catalog first, else whatever distinct set the
-- plugin already computed for its (now unused) enum hint.
local function pick_values(prompt, opts)
  local ok, view = pcall(require, "dadbod-grip.view")
  local session = ok and view._sessions and view._sessions[vim.api.nvim_get_current_buf()]
  local tbl = session and session.state and session.state.table_name
  local col = prompt and prompt:match("([^.]+)$")
  local url = session and (session.url or (session.state and session.state.url))
  if tbl and col and url then
    local v = catalog_values(tbl, col, url)
    if v then return v end
  end
  local hint = opts and opts.enum_values
  if hint and #hint > 0 then return hint end
  return nil
end

-- Dropdown: j/k (+ ctrl variants) move, <CR> pick, <Esc>/q cancel.
-- on_pick follows editor.open's contract: nil = cancel, NULL_VALUE = set NULL.
local function dropdown(values, cur, on_pick, null_value)
  local caller_win = vim.api.nvim_get_current_win()
  local ncur, lines, w, sel = norm(cur), {}, 12, 1
  local entries = {}
  for i, v in ipairs(values) do
    entries[i] = v
    local is = cur ~= nil and norm(v) == ncur
    lines[i] = (is and " ✓ " or "   ") .. v .. " "
    w = math.max(w, vim.fn.strdisplaywidth(lines[i]))
    if is then sel = i end
  end
  entries[#entries + 1] = null_value
  lines[#lines + 1] = (cur == nil and " ✓ " or "   ") .. "NULL "
  if cur == nil then sel = #lines end
  w = math.max(w, vim.fn.strdisplaywidth(lines[#lines]))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  pcall(function() require("cmp").setup.buffer({ enabled = false }) end)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor", row = 1, col = 0,
    width = w, height = math.min(#lines, 10),
    style = "minimal", border = "rounded", zindex = 100,
    footer = "  <CR>=pick  <Esc>=cancel  ", footer_pos = "right",
  })
  vim.api.nvim_win_set_cursor(win, { sel, 0 })

  local o = { buffer = buf, noremap = true, nowait = true }
  local done = false
  local function close(pick)
    if done then return end
    done = true
    pcall(vim.api.nvim_win_close, win, true)
    if vim.api.nvim_win_is_valid(caller_win) then
      pcall(vim.api.nvim_set_current_win, caller_win)
    end
    on_pick(pick) -- nil = cancel
  end
  vim.keymap.set("n", "<CR>", function()
    close(entries[vim.api.nvim_win_get_cursor(win)[1]])
  end, o)
  for _, k in ipairs({ "<Esc>", "q" }) do
    vim.keymap.set("n", k, function() close(nil) end, o)
  end
  local function move(d)
    local r = math.min(math.max(vim.api.nvim_win_get_cursor(win)[1] + d, 1), #lines)
    vim.api.nvim_win_set_cursor(win, { r, 0 })
  end
  for _, k in ipairs({ "j", "<C-j>", "<C-n>", "<Down>" }) do
    vim.keymap.set("n", k, function() move(1) end, o)
  end
  for _, k in ipairs({ "k", "<C-k>", "<C-p>", "<Up>" }) do
    vim.keymap.set("n", k, function() move(-1) end, o)
  end
end

function M.setup()
  if wrapped then return end
  local ok, editor = pcall(require, "dadbod-grip.editor")
  if not ok then return end
  wrapped = true

  local orig_open = editor.open
  editor.open = function(prompt, initial, on_save, opts)
    local values = pick_values(prompt, opts)
    if values then
      return dropdown(values, initial, on_save, editor.NULL_VALUE)
    end
    return orig_open(prompt, initial, on_save, opts)
  end
end

return M
