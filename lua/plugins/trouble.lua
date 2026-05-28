-- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	config = function()
		require("trouble").setup({})

		vim.keymap.set("n", "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
		vim.keymap.set(
			"n",
			"<leader>tf",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			{ desc = "Buffer Diagnostics (Trouble)" }
		)
		vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
		vim.keymap.set(
			"n",
			"<leader>tl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			{ desc = "LSP Definitions / references / ... (Trouble)" }
		)
		vim.keymap.set("n", "<leader>tlo", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
		vim.keymap.set("n", "<leader>tq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
	end,
}
