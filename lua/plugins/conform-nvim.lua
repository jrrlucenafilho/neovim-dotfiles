-- Formatting, more complete than none-ls
-- Going ot use it for formatters that none-ls doesn't have
-- List is in https://github.com/stevearc/conform.nvim

return {
	"stevearc/conform.nvim",
	opts = {},

	config = function()
		require("conform").setup({
			-- Formatters by filetype go here
			formatters_by_ft = {
				vhdl = { "vsg" },
			},
		})

		----- [[ Keymaps ]] -----
		-- Tries formatting with conform first, then falls back to LSP
		vim.keymap.set("n", "<leader>ff", function()
			require("conform").format({ async = false, lsp_format = "fallback" })
		end, { desc = "Format" })
	end,
}
