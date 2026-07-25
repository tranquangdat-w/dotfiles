local StickyContext = {}
StickyContext.__index = StickyContext

local defaults = {
    context_lines = 2,  -- header + separator
    sidescrolloff = 100,
    augroup = "dynge-dbout-context",
}

local function is_separator_line(line)
    return line ~= "" and line:match("^[%-%+]+$") ~= nil
end

-- Quét ngược từ cursor_row lên đầu buffer để tìm block header gần nhất
local function find_block_header(buf, cursor_row, max_lines)
    local total = vim.api.nvim_buf_line_count(buf)
    local upper = math.min(cursor_row - 1, total)
    for i = upper, 1, -1 do
        local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1] or ""
        if is_separator_line(line) then
            local start = math.max(1, i - (max_lines - 1))
            local lines = vim.api.nvim_buf_get_lines(buf, start - 1, i, false)
            return lines, i  -- lines: {header, separator}; i: dòng separator
        end
    end
    return nil, nil
end

function StickyContext.new(config)
    local buf = vim.api.nvim_get_current_buf()
    local winid = vim.api.nvim_get_current_win()
    local float_buf = vim.api.nvim_create_buf(false, true)

    vim.opt_local.sidescrolloff = config.sidescrolloff

    local self = setmetatable({
        buf = buf,
        winid = winid,
        float_buf = float_buf,
        lines = { "" },
        activate_below = 0,
        current_sep_line = nil,
        context_winid = nil,
        config = config,
    }, StickyContext)

    return self
end

function StickyContext:ensure_float_buf()
    if not (self.float_buf and vim.api.nvim_buf_is_valid(self.float_buf)) then
        self.float_buf = vim.api.nvim_create_buf(false, true)
        self.current_sep_line = nil -- ép refresh_lines nạp lại nội dung ngay bên dưới
    end
end

-- Refresh dựa theo block hiện tại quanh cursor, không phải cố định đầu buffer
function StickyContext:refresh_lines(cursor_row)
    local lines, sep_line = find_block_header(self.buf, cursor_row, self.config.context_lines)

    if not lines then
        -- Không tìm thấy block header nào phía trên -> đang ở block đầu tiên, không cần overlay
        self.lines = { "" }
        self.activate_below = math.huge
        return false
    end

    -- Chỉ update buffer overlay khi đổi sang block khác (tránh set_lines liên tục)
    if self.current_sep_line ~= sep_line then
        self.current_sep_line = sep_line
        self.lines = lines
        self.activate_below = sep_line
        vim.api.nvim_buf_set_lines(self.float_buf, 0, -1, false, lines)
        if self.context_winid and vim.api.nvim_win_is_valid(self.context_winid) then
            vim.api.nvim_win_set_height(self.context_winid, #lines)
        end
    end

    return true
end

function StickyContext:ensure_context_window()
    if self.context_winid and vim.api.nvim_win_is_valid(self.context_winid) then
        return
    end

    local win_width = vim.api.nvim_win_get_width(self.winid)
    local gutter_info = vim.fn.getwininfo(self.winid)[1] or {}
    local gutter_width = gutter_info.textoff or 0
    local width = math.max(1, win_width - gutter_width)

    self.context_winid = vim.api.nvim_open_win(self.float_buf, false, {
        focusable = false,
        row = 0,
        col = gutter_width,
        height = #self.lines,
        width = width,
        relative = "win",
        win = self.winid,
        style = "minimal",
        noautocmd = true,
        border = "none",
    })

    vim.wo[self.context_winid].wrap = false
    vim.wo[self.context_winid].foldenable = false
    vim.wo[self.context_winid].sidescrolloff = self.config.sidescrolloff
end

function StickyContext:close_context_window()
    if self.context_winid and vim.api.nvim_win_is_valid(self.context_winid) then
        vim.api.nvim_win_close(self.context_winid, true)
    end
    self.context_winid = nil
    -- Reset để lần hiện overlay kế tiếp, refresh_lines() luôn nạp lại nội dung
    -- float_buf (nếu không reset, current_sep_line vẫn giữ block cũ -> refresh_lines
    -- tưởng "không có gì đổi" và bỏ qua -> overlay mở ra nhưng rỗng/không hiện lại).
    self.current_sep_line = nil
end

function StickyContext:teardown()
    self:close_context_window()
    if self.float_buf and vim.api.nvim_buf_is_valid(self.float_buf) then
        vim.api.nvim_buf_delete(self.float_buf, { force = true })
    end
end

function StickyContext:update()
    self:ensure_float_buf()

    local cursor = vim.api.nvim_win_get_cursor(self.winid)
    local cursor_row, cursor_col = cursor[1], cursor[2]

    local has_block = self:refresh_lines(cursor_row)

    local topline = vim.fn.line('w0', self.winid)

    -- Chỉ hiện overlay khi: có block header phía trên VÀ header thật đã cuộn khỏi viewport
    if has_block and topline > self.activate_below then
        self:ensure_context_window()
    else
        self:close_context_window()
    end

    if self.context_winid and vim.api.nvim_win_is_valid(self.context_winid) then
        local first_line = self.lines[1] or ""
        local col = cursor_col > #first_line and #first_line or cursor_col
        vim.api.nvim_win_set_cursor(self.context_winid, { 1, col })
    end
end

function StickyContext:attach_autocmds()
    -- Augroup riêng theo buffer, clear=true để không tích tụ instance cũ
    -- mỗi lần attach() được gọi lại trên cùng 1 buffer.
    local group = vim.api.nvim_create_augroup(
        self.config.augroup .. "-" .. self.buf,
        { clear = true }
    )

    vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled", "CursorMovedI" }, {
        group = group,
        buffer = self.buf,
        callback = function()
            if not vim.api.nvim_buf_is_valid(self.buf) then
                self:teardown()
                return
            end

            -- Luôn lấy lại window hiện tại thực tế, KHÔNG tin vào self.winid đã
            -- lưu cố định lúc attach(). Nhờ vậy nếu window cũ bị đóng và buffer
            -- này được mở lại ở 1 window khác, context tự "bắt lại" đúng window
            -- mới mà không cần attach() chạy lại (FileType chỉ fire 1 lần/buffer).
            local win = vim.api.nvim_get_current_win()
            if vim.api.nvim_win_get_buf(win) ~= self.buf then
                -- Event fire nhưng window hiện tại không phải window đang hiển thị
                -- buffer này (ví dụ event từ 1 window khác) -> bỏ qua, không đụng gì.
                return
            end

            if self.winid ~= win then
                -- Window đổi khác window cũ -> đóng overlay cũ (nếu còn) trước khi
                -- gắn sang window mới, tránh treo overlay lơ lửng ở window cũ.
                self:close_context_window()
                self.winid = win
            end

            self:update()
        end,
    })

    -- Dọn dẹp khi buffer dbout bị xoá/unload thật (không dùng BufWinLeave vì
    -- nó fire cả trong tình huống chỉ rời tạm, làm teardown chạy quá sớm
    -- trong khi autocmd CursorMoved cũ vẫn còn sống -> crash lúc gọi lại float_buf).
    vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete", "BufWipeout" }, {
        group = group,
        buffer = self.buf,
        callback = function()
            self:teardown()
        end,
    })

    -- Dọn dẹp khi chính window chứa dbout bị đóng (ví dụ :q trên window đó)
    vim.api.nvim_create_autocmd("WinClosed", {
        group = group,
        callback = function(args)
            local closed_win = tonumber(args.match)
            if closed_win == self.winid then
                self:teardown()
            end
        end,
    })
end

local M = { config = defaults }

function M.setup(opts)
    if opts then
        M.config = vim.tbl_deep_extend("force", {}, defaults, opts)
    end
end

function M.attach(opts)
    local config = vim.tbl_deep_extend("force", {}, M.config, opts or {})
    local instance = StickyContext.new(config)
    instance:attach_autocmds()
    instance:update()
    return instance
end

return M
