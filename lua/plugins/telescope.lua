return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		----------[[ Telescope Modules ]]----------
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local z_utils = require("telescope._extensions.zoxide.utils")

		telescope.setup({
			----------[[ Telescope Extensions ]]----------
			extensions = {
				----------[[ Zoxide ]]----------
				zoxide = {
					prompt_title = "[ Zoxide List oo ee oo ]",

					-- Zoxide list command with score
					list_command = "zoxide query -ls",
					mappings = {
						default = {
							action = function(selection)
								vim.cmd.cd(selection.path)
							end,
							after_action = function(selection)
								vim.notify("Directory changed to " .. selection.path)
							end,
						},
						["<C-s>"] = { action = z_utils.create_basic_command("split") },
						["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
						["<C-e>"] = { action = z_utils.create_basic_command("edit") },
						["<C-f>"] = {
							keepinsert = true,
							action = function(selection)
								builtin.find_files({ cwd = selection.path })
							end,
						},
						["<C-t>"] = {
							action = function(selection)
								vim.cmd.tcd(selection.path)
							end,
						},
					},
				},
			},
		})

		----------[[ Load Extensions ]]----------
		telescope.load_extension("zoxide")
		telescope.load_extension("fidget")

		----------[[ Keymaps ]]----------
		vim.keymap.set("n", "<A-b>", builtin.buffers, { desc = "Telescope list buffers" })
		vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Telescope live grep" })
		-- Open Frecency / MRU
		vim.keymap.set("n", "<leader>fr", function()
			require("telescope").load_extension("frecency")
			require("telescope").extensions.frecency.frecency()
		end, { desc = "Open Frecency / MRU" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>fzb", builtin.current_buffer_fuzzy_find, { desc = "Telescope buffer fuzzy find" })
		vim.keymap.set("n", "<leader>fre", builtin.registers, { desc = "Telescope list registers" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope list normal mode keymaps" })
		vim.keymap.set(
			"n",
			"<leader>z",
			require("telescope").extensions.zoxide.list,
			{ desc = "Telescope Zoxide list" }
		)
	end,
}
