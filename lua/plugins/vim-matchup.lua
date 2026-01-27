-- Better highlighing and navigation for enclosing elements
return {
	"andymass/vim-matchup",
	init = function()
		require("match-up").setup({
			treesitter = {
				stopline = 500,
			},
		})
	end,

	config = function()
		vim.api.nvim_create_augroup("matchup_matchparen_highlight", { clear = true })

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = "matchup_matchparen_highlight",
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "MatchParenCur", { fg = "#b9babb", bg = "#282c34", underline = true })
				vim.api.nvim_set_hl(0, "MatchParen", { fg = "#b9babb", bg = "#282c34", underline = true })
				vim.api.nvim_set_hl(0, "MatchWord", { fg = "NONE", bg = "#282c34", underline = true })
			end,
		})
	end,
}
