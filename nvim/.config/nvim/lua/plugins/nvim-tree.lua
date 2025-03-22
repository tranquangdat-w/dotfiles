return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
    vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- optionally enable 24-bit colour
		vim.opt.termguicolors = true

		require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive"
      },
      view = {
        width = 35
      },
      git = {
        ignore = false,
      },
		  renderer = {
        highlight_modified = "icon",
		    icons = {
		      show = {
			      git = false,
			      file = true,
			      folder = false,
			      folder_arrow = true,
            modified = true,
		      },
		      glyphs = {
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
