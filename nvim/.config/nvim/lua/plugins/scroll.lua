return {
	"karb94/neoscroll.nvim",
	opts = {},
	config = function()
		local neoscroll = require("neoscroll")

		require("neoscroll").setup({
			hide_cursor = false, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at <EOF> when scrolling downwards
			respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
			duration_multiplier = 0.8, -- Global duration multiplier
			easing = "linear", -- Default easing function
			pre_hook = nil, -- Function to run before the scrolling animation starts
			post_hook = nil, -- Function to run after the scrolling animation ends
			performance_mode = false, -- Disable "Performance Mode" on all buffers.
			ignored_events = { -- Events ignored while scrolling
				"WinScrolled",
				"CursorMoved",
			},
		})
		local keymap = {
			["<C-u>"] = { func = function()
				neoscroll.ctrl_u({ duration = 300 })
			end, desc = "Scroll up" },
			["<C-d>"] = { func = function()
				neoscroll.ctrl_d({ duration = 300 })
			end, desc = "Scroll down" },
			["zz"] = { func = function()
				neoscroll.zz({ half_win_duration = 300 })
			end, desc = "Center screen" },
			["zb"] = { func = function()
				neoscroll.zb({ half_win_duration = 300 })
			end, desc = "Scroll to bottom" },
		}
		local modes = { "n", "v", "x" }
		for key, data in pairs(keymap) do
			vim.keymap.set(modes, key, data.func, { desc = data.desc })
		end
	end,
}
