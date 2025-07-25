return {
	"nvim-java/nvim-java",
	config = function()
		require("java").setup({})
		require("lspconfig").jdtls.setup({
    })

    vim.api.nvim_create_user_command("JRRM", "JavaRunnerRunMain", {desc = "Running Java main class"})
	end,
}
-- https://github.com/nvim-java/nvim-java?tab=readme-ov-file
-- return {}
