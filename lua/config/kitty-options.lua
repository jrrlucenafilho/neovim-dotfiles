-- Kitty margin management
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			vim.cmd("silent !kitty @ set-spacing margin=0")
		end, 10)
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		vim.cmd("silent !kitty @ set-spacing margin=21.75")
	end,
})
