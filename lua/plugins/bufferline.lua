-- Tab-like behavior for buffers
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				-- mode = "tabs",
				offsets = {
          {
            filetype = "neo-tree",
            text = "NeoTree",
            text_align = "center",
            separator = true,
				  }
        },
			},
		})

		-- Bufferline keymaps
		-- Go to the next buffer
		vim.keymap.set("n", "<A-Right>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Cycle to next buffer"})

		-- Go to the previous buffer
		vim.keymap.set("n", "<A-Left>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Cycle to previous buffer"})

		-- Close current buffer
		-- Disabled cause I'm using LazyVim's custom buf closing function
		--vim.keymap.set("n", "<A-q>", "<Cmd>bd<CR>", {})
	end,
}
