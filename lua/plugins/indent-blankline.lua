-- Indenatation lines
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	--- @module "ibl"
	--- @type ibl.config
	opts = {},

	config = function()
		-- OneDark-exclusive highlight for cursor scope
		local highlight = {
			"OneDarkBlue",
		}

		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "OneDarkBlue", { fg = "#5ea5df" })
		end)

		require("ibl").setup({
			indent = {
				-- no highlight here: this would color every indent level
			},
			scope = {
				enabled = true,
				highlight = highlight,
			},
		})
	end,
}
