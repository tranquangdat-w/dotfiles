-- all vim helper functions here

vim.keymap.set("n", "<leader>ce", function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diagnostics > 0 then
        local message = diagnostics[1].message
        vim.fn.setreg("+", message)
        print("Copied diagnostic: " .. message)
    else
        print("No diagnostic at cursor")
    end
end, { noremap = true, silent = true })

-- go to errors in a file :/
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next) -- next err
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev) -- previous err

vim.keymap.set("n", "<leader>ob", function()
	local file_path = vim.fn.expand("%:p") -- get the current file path
	if file_path ~= "" then
		local cmd = ""
		-- Kiểm tra firefox có tồn tại không
		local has_firefox = vim.fn.executable("firefox") == 1
		local has_chrome = vim.fn.executable("google-chrome-stable") == 1 or vim.fn.executable("google-chrome") == 1

		if has_firefox then
			cmd = "firefox " .. vim.fn.shellescape(file_path)
		elseif has_chrome then
			local chrome = vim.fn.executable("google-chrome-stable") == 1 and "google-chrome-stable" or "google-chrome"
			cmd = chrome .. " " .. vim.fn.shellescape(file_path)
		else
			print("No supported browser found (firefox or google-chrome)")
			return
		end

		os.execute(cmd .. " &")
	else
		print("No file to open")
	end
end, { desc = "Open current file in browser" })

vim.api.nvim_create_user_command("ShowTree", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local editor_width = vim.o.columns
	local editor_height = vim.o.lines
	local width = math.floor(editor_width * 0.6)
	local height = math.floor(editor_height * 0.9)

	local row = math.floor((editor_height - height) / 2)
	local col = math.floor((editor_width - width) / 2)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		style = "minimal",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)
	local job_id = vim.fn.jobstart("tree -L 4", {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					vim.api.nvim_buf_set_lines(buf, -1, -1, true, { line })
				end
			end
		end,
		on_exit = function()
			-- vim.api.nvim_win_close(win, true)
		end,
	})
	print("Job ID: " .. job_id)
end, {})

vim.keymap.set("n", "<leader>vt", ":ShowTree<CR>", { desc = "Show directory tree in floating window" })
