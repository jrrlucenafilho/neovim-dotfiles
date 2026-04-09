-- Tab-like behavior for buffers
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				-- mode = "tabs",
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "neo-tree",
						text = "NeoTree",
						text_align = "center",
						separator = true,
					},
					{
						filetype = "codecompanion",
						text = "Code Companion",
						text_align = "center",
						separator = true,
					},
					{
						filetype = "Outline",
						text = "Outline",
						text_align = "center",
						separator = true,
					},
					{
						filetype = "dapui_watches",
						text = "Nvim-DAP",
						text_align = "center",
						separator = true,
					},
				},
			},
		})

		-- Bufferline keymaps
		-- Go to the next buffer
		vim.keymap.set("n", "<A-Right>", "<cmd>BufferLineCycleNext<CR>", { desc = "Cycle to next buffer" })

		-- Go to the previous buffer
		vim.keymap.set("n", "<A-Left>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Cycle to previous buffer" })

		-- Move current buffer to the left
		vim.keymap.set("n", "<S-Left>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer to the left" })

		-- Move current buffer to the right
		vim.keymap.set("n", "<S-Right>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer to the right" })

		-- Toggle pin on a buffer tab
		vim.keymap.set("n", "<S-p>", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })

		-- Close current buffer
		-- Disabled cause I'm using LazyVim's custom buf closing function
		--vim.keymap.set("n", "<A-q>", "<Cmd>bd<CR>", {})

		----- [[ Miscellaneous Configs ]] -----
		vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { fg = "#464e6a", bg = "NONE" })
	end,
}
