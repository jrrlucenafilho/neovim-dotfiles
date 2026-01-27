-- Multiple cursors functionality
return {
	"smoka7/multicursors.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvimtools/hydra.nvim",
	},
	opts = {},
	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	keys = {
		{
			mode = { "v", "n" },
			"<Leader>mw",
			"<cmd>MCstart<CR>",
			desc = "MultiCursors start on a word",
		},
		{
			mode = { "v", "n" },
			"<Leader>mc",
			"<cmd>MCunderCursor<CR>",
			desc = "MultiCursors start at cursor",
		},
	},
}
