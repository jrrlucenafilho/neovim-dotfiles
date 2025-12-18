-- Responsible for linting and formatting
-- Install linters/formatters with Mason
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- Javascript
				null_ls.builtins.formatting.prettier,
				require("none-ls.diagnostics.eslint_d"),

				-- Python
				null_ls.builtins.formatting.black, -- general formatting
				null_ls.builtins.formatting.isort, -- imports formatting
				require("none-ls.diagnostics.ruff"), -- linter

				-- Html
				-- null_ls.builtins.formatting.prettier, -- (already included)
				-- null_ls.builtins.diagnostics.htmlhint, -- We're using lsp linting
			},
		})

		-- Formatting/Linting keybinds
		vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { desc = "Format" })
	end,
}
