-- Reopen closed buffers
return {
	"iamyoki/buffer-reopen.nvim",
	event = "VeryLazy",

	config = function()
		require("buffer-reopen").setup({})

		----- [[ Keymaps ]] -----
		vim.keymap.set("n", "<A-u>", "<cmd>BufferHistory reopen<cr>", { silent = true })
		vim.keymap.set("n", "<leader>cb", "<cmd>BufferHistory show_closed<cr>", { silent = true })
	end,
}
