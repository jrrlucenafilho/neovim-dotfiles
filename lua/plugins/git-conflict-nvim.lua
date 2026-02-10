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
				ours = "<leader>gco",
				theirs = "<leader>gct",
				none = "<leader>gc0",
				both = "<leader>gcb",
				next = "<leader>gcn",
				prev = "<leader>gcp",
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
			-- Toggle conflict list
			vim.keymap.set("n", "<leader>gcl", function()
				local qf_open = false
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "buftype") == "quickfix" then
						qf_open = true
						break
					end
				end
				if qf_open then
					vim.cmd("cclose")
				else
					vim.cmd("GitConflictListQf")
				end
			end, { desc = "Toggle Git Conflict List" }),
		})
	end,
}
