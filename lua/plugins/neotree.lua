return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
		"s1n7ax/nvim-window-picker",
	},
	lazy = false, -- neo-tree will lazily load itself

	config = function()
		require("neo-tree").setup({
			window = {
				width = 30,
				mappings = {
					["<C-r>"] = "refresh",
				},
			},
		})
		vim.keymap.set({ "n" }, "<C-n>", ":Neotree toggle left<CR>", { desc = "Neotree toggle right" })

		-- Autocmd to auto update neotree after neogit commits or pushes
		vim.api.nvim_create_autocmd("User", {
			pattern = { "NeogitCommitComplete", "NeogitPushComplete" },
			callback = function()
				require("neo-tree.sources.manager").refresh("filesystem")
			end,
		})
	end,
}
