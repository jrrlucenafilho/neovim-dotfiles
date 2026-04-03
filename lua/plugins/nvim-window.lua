-- Quickly navigate between open windows
return {
	"yorickpeterse/nvim-window",
	keys = {
		{
			mode = { "n", "t" },
			",",
			"<cmd>lua require('nvim-window').pick()<cr>",
			desc = "Jump to window",
		},
	},
	config = true,
}
