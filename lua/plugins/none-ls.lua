-- Responsible for linting and formatting
-- Install linters/formatters with Mason
-- Builtins: https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins
-- Extras: https://github.com/nvimtools/none-ls-extras.nvim/tree/main/lua/none-ls
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},

	config = function()
		local none_ls = require("null-ls")

		none_ls.setup({
			----------[[ Linters/Formatters ]]----------
			sources = {
				---[[ Lua ]]---
				none_ls.builtins.formatting.stylua,
				-- none_ls.builtins.diagnostics.selene, -- Using Selene on nvim-lint

				---[[ Typescript/Javascript ]]--
				none_ls.builtins.formatting.prettier,
				none_ls.builtins.diagnostics.semgrep,
				-- require("none-ls.diagnostics.eslint_d"), -- Superceded by eslint_lsp

				---[[ Python ]]---
				none_ls.builtins.formatting.black, -- general formatting
				none_ls.builtins.formatting.isort, -- imports formatting
				require("none-ls.diagnostics.ruff"), -- linter

				---[[ Html ]]---
				-- none_ls.builtins.formatting.prettier, -- (already included)
				-- none_ls.builtins.diagnostics.htmlhint, -- Superceded by Html-lsp

				---[[ Css ]] --
				none_ls.builtins.diagnostics.stylelint,
				-- none_ls.builtins.formatting.prettier, -- (already included)

				---[[ C/C++ ]]---
				none_ls.builtins.formatting.clang_format,
				none_ls.builtins.diagnostics.cppcheck, -- Not in Mason, complementing clangtidy
			},
		})

		-- Formatting keymaps
		vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { desc = "Format" })
	end,
}
