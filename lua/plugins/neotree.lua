return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{ -- For LSP-enhanced filenames
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-neo-tree/neo-tree.nvim",
			},
			config = function()
				require("lsp-file-operations").setup()
			end,
		},
		{ -- For _with_window_picker keymaps
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify", "Outline", "codecompanion" },
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			window = {
				width = 30,
				mappings = {
					["<C-r>"] = "refresh",
					["p"] = {
						"toggle_preview",
						config = {
							use_float = true,
							use_image_nvim = true,
						},
					},
				},
			},
		})
		vim.keymap.set({ "n" }, "<C-t>", "<cmd>Neotree toggle left<cr>", { desc = "Neotree toggle left" })

		vim.api.nvim_create_autocmd("User", {
			pattern = { "NeogitCommitComplete", "NeogitPushComplete" },
			callback = function()
				require("neo-tree.sources.manager").refresh("filesystem")
			end,
		})
	end,
}
