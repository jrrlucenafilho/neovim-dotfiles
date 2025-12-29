-- Linting, more complete than none-ls
-- Going ot use it for linters that none-ls doesn't have
-- List is in https://github.com/mfussenegger/nvim-lint

return {
	"mfussenegger/nvim-lint",

	config = function()
		require("lint").linters_by_ft = {
      ----------[[ Linters ]]----------
			cpp = { "clangtidy" }, -- Complementing cppcheck
			lua = { "selene" },
		}

		-- Autocmd for linting
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			callback = function()
				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				require("lint").try_lint()

				-- You can call `try_lint` with a linter name or a list of names to always
				-- run specific linters, independent of the `linters_by_ft` configuration
				-- require("lint").try_lint("cspell")
			end,
		})

		-- Command for checking nvim-lint info on current buffer
		vim.api.nvim_create_user_command("NvimLintInfo", function()
			print(vim.inspect(require("lint").linters_by_ft[vim.bo.filetype]))
		end, {})
	end,
}
