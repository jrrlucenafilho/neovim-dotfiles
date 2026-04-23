-- Helps you better glance at matched information, seamlessly jump between matched instances
return {
	"kevinhwang91/nvim-hlslens",

	config = function()
		require("hlslens").setup()
		local kopts = { noremap = true, silent = true }

		vim.keymap.set(
			"n",
			"n",
			[[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>]],
			kopts
		)
		vim.keymap.set(
			"n",
			"N",
			[[<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>]],
			kopts
		)
		vim.keymap.set("n", "*", [[*<cmd>lua require('hlslens').start()<cr>]], kopts)
		vim.keymap.set("n", "#", [[#<cmd>lua require('hlslens').start()<cr>]], kopts)
		vim.keymap.set("n", "g*", [[g*<cmd>lua require('hlslens').start()<cr>]], kopts)
		vim.keymap.set("n", "g#", [[g#<cmd>lua require('hlslens').start()<cr>]], kopts)

		vim.keymap.set("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
	end,
}
