-- Enables working with Quarto manuscripts in neovim
-- (Used in Molten for code cells)
return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},

	config = function()
		local quarto = require("quarto")
		quarto.setup({
			lspFeatures = {
				-- NOTE: put whatever languages you want here:
				languages = { "r", "python", "rust", "c", "cpp" },
				chunks = "all",
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			keymap = {
				-- NOTE: setup your own keymaps:
				hover = "<localleader>h",
				definition = "<localleader>gd",
				rename = "<localleader>rn",
				references = "<localleader>gr",
				format = "<localleader>gf",
			},
			codeRunner = {
				enabled = true,
				default_method = "molten",
			},
		})
	end,
  }
}
