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
			"gmcw",
			"<cmd>MCstart<CR>",
			desc = "MultiCursors: Start on word",
		},
		{
			mode = { "v", "n" },
			"gmcc",
			"<cmd>MCunderCursor<CR>",
			desc = "MultiCursors: Start under cursor",
		},
		{
			mode = { "v", "n" },
			"gmcv",
			"<cmd>MCvisual<CR>",
			desc = "MultiCursors: Last visual selection",
		},
		{
			mode = { "v", "n" },
			"gmcp",
			"<cmd>MCpattern<CR>",
			desc = "MultiCursors: Pattern",
		},
	},
}
