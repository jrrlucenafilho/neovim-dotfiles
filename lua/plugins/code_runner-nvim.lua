-- Code runner, like vscode's
return {
	"CRAG666/code_runner.nvim",
	-- config = true,

	config = function()
		require("code_runner").setup({
			filetype = {
				python = "uv run python",
				c = "cd $dir && gcc $fileName -g -o  /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
				cpp = "cd $dir && g++ $fileName -g -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
			},
		})

		-- Keybindings
		vim.keymap.set(
      "n",
      "<leader>cr",
      ":RunCode<CR>",
      { noremap = true, silent = false, desc = "Run code" }
    )
		vim.keymap.set(
      "n",
      "<leader>crf",
      ":RunFile<CR>",
      { noremap = true, silent = false, desc = "Run file" }
    )
		vim.keymap.set(
			"n",
			"<leader>crftb",
			":RunFile tab<CR>",
			{ noremap = true, silent = false, desc = "Run file tab" }
		)
		vim.keymap.set("n",
      "<leader>crp",
      ":RunProject<CR>",
      { noremap = true, silent = false, desc = "Run project" }
    )
		vim.keymap.set("n",
      "<leader>crq",
      ":RunClose<CR>",
      { noremap = true, silent = false, desc = "Run close" }
    )
		vim.keymap.set("n",
      "<leader>crft",
      ":CRFiletype<CR>",
      { noremap = true, silent = false, desc = "CR filetype" }
    )
		vim.keymap.set("n",
    "<leader>crps",
      ":CRProjects<CR>",
      { noremap = true, silent = false, desc = "CR projects" }
    )
	end,
}
