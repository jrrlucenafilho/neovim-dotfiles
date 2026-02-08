-- Deals with git conflicts
return {
	"akinsho/git-conflict.nvim",
	version = "*",
	dependencies = { "yorickpeterse/nvim-pqf" },

	config = function()
		require("git-conflict").setup({
			{
				default_mappings = true, -- disable buffer local mapping created by this plugin
				default_commands = true, -- disable commands created by this plugin
				disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
				list_opener = "copen", -- command or function to open the conflicts list
				highlights = { -- They must have background color, otherwise the default color will be used
					incoming = "DiffAdd",
					current = "DiffText",
				},
			},
			default_mappings = {
				ours = "<localleader>co",
				theirs = "<localleader>ct",
				none = "<localleader>c0",
				both = "<localleader>cb",
				next = "<localleader>cn",
				prev = "<localleader>cp",
			},
		})

		-- Autocmd to start plugin upon conflicts
		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictDetected",
			callback = function()
				vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
				vim.keymap.set("n", "cww", function()
					engage.conflict_buster()
					create_buffer_local_mappings()
				end)
			end,
			-- Extra Keymaps
			-- Open conflict list
			vim.keymap.set("n", "<localleader>cl", "<cmd>GitConflictListQf<cr>", { desc = "Open conflict list" }),
		})
	end,
}
