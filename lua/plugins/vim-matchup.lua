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
				vim.api.nvim_set_hl(0, "MatchParen", { fg = "#1a1b26", bg = "#ff9e64", underline = false })
				vim.api.nvim_set_hl(0, "MatchParenCur", { fg = "#1a1b26", bg = "#ff9e64", underline = false })
				vim.api.nvim_set_hl(0, "MatchWord", { fg = "NONE", bg = "#343b58", underline = true })
			end,
		})
	end,
}
