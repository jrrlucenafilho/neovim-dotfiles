return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	config = function()
		require("onedarkpro").setup({
			colors = {
				onedark = { bg = "#16191D" },
			},
		})

		-- Autocmd to save color scheme to file, onedark as fallback
		local config_dir = vim.fn.stdpath("config")
		local theme_file = config_dir .. "/colorscheme"
		local theme_lines = {}

		if vim.fn.filereadable(theme_file) == 1 then
			theme_lines = vim.fn.readfile(theme_file, "", 1)
		end

		local theme = (#theme_lines > 0) and theme_lines[1] or "onedark"
		vim.cmd("colorscheme " .. theme)

		-- Saves colorscheme on change
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("SaveColorScheme", { clear = true }),
			callback = function()
				local current_scheme = vim.g.colors_name
				vim.fn.writefile({ current_scheme }, theme_file)
			end,
		})
	end,
}
