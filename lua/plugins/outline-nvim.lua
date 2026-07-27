-- Outline sidebar
return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<C-o>", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {
		outline_window = {
			position = "right",
			width = 15,
		},
	},
	config = function(_, opts)
		require("outline").setup(opts)

		vim.keymap.set("n", "<leader>eo", function()
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win) })
				if ft == "Outline" then
					local cur_width = vim.api.nvim_win_get_width(win)
					local default_width = 35
					local expanded_width = 70
					vim.api.nvim_win_set_width(win, cur_width == expanded_width and default_width or expanded_width)
					return
				end
			end
		end, { desc = "Toggle outline width" })
	end,
}
