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
			"<CMD>MCstart<CR>",
			desc = "MultiCursors: Start on word",
		},
		{
			mode = { "v", "n" },
			"gmcc",
			"<CMD>MCunderCursor<CR>",
			desc = "MultiCursors: Start under cursor",
		},
		{
			mode = { "v", "n" },
			"gmcv",
			"<CMD>MCvisual<CR>",
			desc = "MultiCursors: Last visual selection",
		},
		{
			mode = { "v", "n" },
			"gmcp",
			"<CMD>MCpattern<CR>",
			desc = "MultiCursors: Pattern",
		},
		{
			mode = { "v", "n" },
			"gmcr",
			"<CMD>MCclear<CR>",
			desc = "MultiCursors: Remove/Clear",
		},
	},
}
