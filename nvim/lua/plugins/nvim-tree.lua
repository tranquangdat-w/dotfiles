return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- optionally enable 24-bit colour
		vim.opt.termguicolors = true

		require("nvim-tree").setup({
      git = {
        ignore = false,
      },
		  renderer = {
        highlight_modified = "icon",
		    icons = {
		      show = {
			      git = false,
			      file = true,
			      folder = true,
			      folder_arrow = true,
            modified = true,
		      },
		      glyphs = {
			      folder = {
			        arrow_closed = "⏵",
			        arrow_open = "⏷",
			      },
            modified = "●",
			      git = {
			        unstaged = "✗",
			        staged = "✓",
			        unmerged = "⌥",
			        renamed = "➜",
			        untracked = "★",
			        deleted = "⊖",
			        ignored = "◌",
			      },
		      },
		    },
		  },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
		})
	end
}

