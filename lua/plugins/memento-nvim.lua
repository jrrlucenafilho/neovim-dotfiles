-- When a buffer is deleted (e.g.: :q, :bd) memento.nvim stores the filepath, and current line number so you can check your history and easily go back to a file.
return {
	"gaborvecsei/memento.nvim",
	-- event = "VeryLazy",

	config = function()
		vim.g.memento_shorten_path = false
		vim.g.memento_window_width = 100
		----- [[ Keymaps ]] -----
		vim.keymap.set("n", "<leader>mh", require("memento").toggle, { desc = "Memento history" })
		vim.keymap.set("n", "<leader>mq", require("memento").clear_history, { desc = "Memento clear history" })
	end,
}
