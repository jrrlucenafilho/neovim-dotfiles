-- Util functions for commit-ptbr.md
return {
	diff = function()
		return vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait().stdout
	end,
}
