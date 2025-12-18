-- Rainbow delimiters, duh
return {
	"HiPhish/rainbow-delimiters.nvim",

	config = function()
		---@type rainbow_delimiters.config
		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = "rainbow-delimiters.strategy.global",
				vim = "rainbow-delimiters.strategy.local",
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			priority = {
				[""] = 110,
				lua = 210,
			},
			highlight = {
				"RainbowDelimiterOrange",
				"RainbowDelimiterViolet",
				"RainbowDelimiterBlue",
				"RainbowDelimiterYellow",
				"RainbowDelimiterCyan",
				"RainbowDelimiterGreen",
				"RainbowDelimiterRed",
			},
		}
	end,
}
