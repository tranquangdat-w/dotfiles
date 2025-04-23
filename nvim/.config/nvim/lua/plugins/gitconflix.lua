return {
    'akinsho/git-conflict.nvim',
    versino = "*",
    config = function()
        require("git-conflict").setup({
            default_mappings = true, -- Tắt mapping mặc định nếu bạn muốn tự định nghĩa
            default_commands = true, -- Giữ nguyên các lệnh mặc định
            disable_diagnostics = true, -- Tắt diagnostics khi buffer đang có xung đột
            list_opener = 'copen', -- Sử dụng lệnh 'copen' để mở danh sách xung đột
            highlights = {
                incoming = 'DiffAdd', -- Highlight cho thay đổi incoming
                current = 'DiffText', -- Highlight cho thay đổi hiện tại
            }
        })
    end,
}
