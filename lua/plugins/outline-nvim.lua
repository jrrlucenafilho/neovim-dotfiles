-- Outline sidebar
return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<C-o>", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {
		-- Your setup opts here
	},
}
