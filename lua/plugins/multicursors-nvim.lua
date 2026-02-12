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
			"gmw",
			"<CMD>MCstart<CR>",
			desc = "MultiCursors: Start on word",
		},
		{
			mode = { "v", "n" },
			"gmc",
			"<CMD>MCunderCursor<CR>",
			desc = "MultiCursors: Start under cursor",
		},
		{
			mode = { "v", "n" },
			"gmv",
			"<CMD>MCvisual<CR>",
			desc = "MultiCursors: Last visual selection",
		},
		{
			mode = { "v", "n" },
			"gmp",
			"<CMD>MCpattern<CR>",
			desc = "MultiCursors: Pattern",
		},
		{
			mode = { "v", "n" },
			"gmr",
			"<CMD>MCclear<CR>",
			desc = "MultiCursors: Remove/Clear",
		},
	},
}
