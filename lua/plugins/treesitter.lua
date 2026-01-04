-- Responsible for code parsing
-- highlighting, better syntax, indentation and navigation

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true,
			ensure_installed = {
				"lua",
				"javascript",
				"c",
				"cpp",
				"html",
				"python",
				"arduino",
				"nasm",
				"java",
				"markdown",
				"markdown_inline",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
