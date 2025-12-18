return {
	"nvim-telescope/telescope.nvim",
	opts = {
		extensions = {
			["zoxide"] = {},
		},
	},
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		require("telescope").load_extension("zoxide") --zoxide integration
		require("telescope").load_extension("fidget") --fidget integration
		vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Live grep" })
	end,
}
