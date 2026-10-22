-- Scrollbar, duh
return {
	"petertriho/nvim-scrollbar",
	branch = "refactor/v2", -- TODO: Remove this once it comes to main
	dependencies = {
		"kevinhwang91/nvim-hlslens",
		"lewis6991/gitsigns.nvim",
	},

	config = function()
		-- Colors, depends on colorscheme
		local colors = require("onedarkpro.helpers").get_colors()

		require("gitsigns").setup()

		require("scrollbar").setup({
			marks = {
				Search = { highlight = { fg = colors.orange } },
				Error = { highlight = { fg = colors.red } },
				Warn = { highlight = { fg = colors.yellow } },
				Info = { highlight = { fg = colors.blue } },
				Hint = { highlight = { fg = colors.cyan } },
				Misc = { highlight = { fg = colors.purple } },
			},
			exclude = { filetypes = { NvimTree = true } },
			providers = { gitsigns = true },
			scrollbar = {
				visibility = "active",
				thumb = {
					text = " ",
					highlight = { bg = colors.selection },
				},
			},
		})
	end,
}
