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
end, { noremap = true, silent = true, desc = "Copy diagnostic message" })

-- go to errors in a file :/
vim.keymap.set("n", "<leader>ne", function()
  vim.diagnostic.goto_next({
    float = { border = "rounded" },
  })
end, { desc = "Next diagnostic (with border)" })

vim.keymap.set("n", "<leader>pe", function()
  vim.diagnostic.goto_prev({
    float = { border = "rounded" },
  })
end, { desc = "Previous diagnostic (with border)" })

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

