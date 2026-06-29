-- Highlight and search for todo comments like TODO, HACK, BUG, PERF, NOTE, FIX, WARNING
return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		require("todo-comments").setup({})

		-- [[ Keymaps ]]
		vim.keymap.set("n", "<leader>tcn", function()
			require("todo-comments").jump_next()
		end, { desc = "Next todo comment" })

		vim.keymap.set("n", "<leader>tcp", function()
			require("todo-comments").jump_prev()
		end, { desc = "Previous todo comment" })

		vim.keymap.set("n", "tce", function()
			require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
		end, { desc = "Next error/warning todo comment" })

		vim.keymap.set("n", "<leader>tcl", "<cmd>TodoTelescope<cr>", { desc = "List all todo comments" })
	end,
}
