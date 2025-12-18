-- Live previewing web-related files
return {
	"brianhuster/live-preview.nvim",
	dependencies = {
		-- You can choose one of the following pickers
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- Keymaps
		vim.keymap.set("n", "<leader>lp", ":LivePreview start<CR>", { desc = "Live preview start" })
		vim.keymap.set("n", "<leader>lpc", ":LivePreview close<CR>", { desc = "Live preview close" })
		vim.keymap.set("n", "<leader>lpp", ":LivePreview pick<CR>", { desc = "Live preview pick file" })
	end,
}
