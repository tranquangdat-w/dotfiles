-- Enum/boolean picker + esc-to-normal text editor for dadbod-grip cell edits.
local M = {}

local type_cache, val_cache = {}, {}

local function norm(v)
  v = tostring(v or ""):lower()
  if v == "t" or v == "1" or v == "yes" then return "true" end
  if v == "f" or v == "0" or v == "no" then return "false" end
  return v
end

local function url_for(bufnr)
  local url = vim.b[bufnr].db or vim.g.db
  if url and url ~= "" then return url end
  local ok, view = pcall(require, "dadbod-grip.view")
  local s = ok and view._sessions and view._sessions[bufnr]
  return s and s.url
end

-- Returns a list of allowed values for enum/boolean columns, else nil.
local function cell_values(tbl, col, url)
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

local function float(buf, width, height, title)
  return vim.api.nvim_open_win(buf, true, {
    relative = "cursor", row = 1, col = 0, width = width, height = height,
    style = "minimal", border = "rounded", zindex = 100,
    title = title, title_pos = title and "center" or nil,
  })
end

-- Text editor: insert <Esc> → normal; normal <Esc>/q → cancel; <C-s>/<CR> → save.
local function text_editor(prompt, initial, on_save)
  local fill = vim.split(initial or "", "\n", { plain = true })
  local w = 30
  for _, l in ipairs(fill) do w = math.max(w, #l + 6) end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, fill)
  local win = float(buf, math.min(80, w), math.min(10, #fill), "󰤌 " .. prompt)
  vim.cmd("startinsert!")

  local done = false
  local function finish(save)
    if done then return end
    done = true
    local val = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
    pcall(vim.api.nvim_win_close, win, true)
    if save then on_save(val) end
  end

  local o = { buffer = buf, noremap = true, nowait = true }
  vim.keymap.set("i", "<Esc>", "<C-\\><C-n>", o)
  vim.keymap.set("n", "<Esc>", function() finish(false) end, o)
  vim.keymap.set("n", "q", function() finish(false) end, o)
  vim.keymap.set("n", "<CR>", function() finish(true) end, o)
  vim.keymap.set({ "i", "n" }, "<C-s>", function() finish(true) end, o)
end

-- Dropdown: j/k (+ ctrl variants) move, <CR> pick, <Esc>/q cancel.
local function dropdown(values, cur, on_pick)
  local ncur, lines, w, sel = norm(cur), {}, 10, 1
  for i, v in ipairs(values) do
    local is = norm(v) == ncur
    lines[i] = (is and " ✓ " or "   ") .. v .. " "
    w = math.max(w, #lines[i])
    if is then sel = i end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  pcall(function() require("cmp").setup.buffer({ enabled = false }) end)

  local win = float(buf, w, math.min(#values, 10))
  vim.api.nvim_win_set_cursor(win, { sel, 0 })

  local o = { buffer = buf, noremap = true, nowait = true }
  local function close(pick)
    pcall(vim.api.nvim_win_close, win, true)
    if pick then on_pick(pick) end
  end
  vim.keymap.set("n", "<CR>", function() close(values[vim.api.nvim_win_get_cursor(win)[1]]) end, o)
  for _, k in ipairs({ "<Esc>", "q" }) do
    vim.keymap.set("n", k, function() close() end, o)
  end
  local function move(d)
    local r = math.min(math.max(vim.api.nvim_win_get_cursor(win)[1] + d, 1), #values)
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
  local grp = vim.api.nvim_create_augroup("GripEditorCompletion", { clear = true })
  -- BufEnter (not WinEnter): grip reuses the window via nvim_win_set_buf.
  vim.api.nvim_create_autocmd("BufEnter", {
    group = grp,
    callback = function(args)
      local buf = args.buf
      if vim.b[buf]._grip_setup or not vim.api.nvim_buf_get_name(buf):match("^grip://") then
        return
      end
      vim.schedule(function()
        if vim.b[buf]._grip_setup then return end
        local ok, view = pcall(require, "dadbod-grip.view")
        local session = ok and view._sessions and view._sessions[buf]
        if not session then return end
        vim.b[buf]._grip_setup = true

        session.on_edit = function(b, cell)
          local tbl = session.state.table_name or "row"
          local function save(v)
            local ok_d, data = pcall(require, "dadbod-grip.data")
            if ok_d then view.apply_edit(b, data.add_change(session.state, cell.row_idx, cell.col_name, v)) end
          end
          local url = session.url or url_for(b)
          local values = url and cell_values(tbl, cell.col_name, url)
          if values then
            dropdown(values, tostring(cell.value or ""), save)
          else
            text_editor(tbl .. "." .. cell.col_name, cell.value, save)
          end
        end
      end)
    end,
  })
end

return M
