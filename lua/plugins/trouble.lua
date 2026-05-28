-- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>td",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>tf",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>ts",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>tl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>tlo",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>tq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
		({
			"<leader>er",
			function()
				local trouble_win
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == "trouble" then
						trouble_win = win
						break
					end
				end
				if not trouble_win then
					vim.notify("Trouble window not found")
					return
				end

				local cur_height = vim.api.nvim_win_get_height(trouble_win)

				if vim.g.trouble_normal_height then
					vim.api.nvim_win_set_height(trouble_win, vim.g.trouble_normal_height)
					vim.g.trouble_normal_height = nil
				else
					vim.g.trouble_normal_height = cur_height
					local half_screen = math.floor((vim.o.lines - vim.o.cmdheight - 1) / 2)
					vim.api.nvim_win_set_height(trouble_win, half_screen)
				end
			end,
			desc = "Toggle Trouble height",
		}),
	},
}
