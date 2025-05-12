return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {},
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				preview = {
          layout = "vertical",
				},
			},
			fzf_colors = {
				true,
				bg = "-1",
				gutter = "-1",
			},
		})
		vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>pf", fzf.git_files, { desc = "Find Git Files" })
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fG", function()
			require("fzf-lua").live_grep({
				rg_opts = "--hidden --glob '!.git/*' --column --line-number --no-heading --color=always -e",
			})
		end, { desc = "Live Grep includes hidden files" })
		vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
		vim.keymap.set("n", "<leader>fs", function()
			fzf.grep({ search = vim.fn.input("Grep For > ") })
		end, { desc = "FZF grep with input" })
	end,
}
