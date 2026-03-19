-- Kanagawa color scheme
return {
	"rebelot/kanagawa.nvim",
	name = "kanagawa",
	priority = 1000,

	config = function()
		-- Default options:
		require("kanagawa").setup({
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			-- overrides = function(colors) -- add/modify highlights
				-- return {}
			-- end,
			theme = "wave", -- Load "wave" theme
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus",
			},
		})
		-- If enabling the Compilation option
		--" 1. Modify your config
		--" 2. Restart nvim
		--" 3. Run this command:
		--" 4. Run ':KanagawaCompile'
	end,
}
