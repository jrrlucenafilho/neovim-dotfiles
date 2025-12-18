-- Session manager
-- (mainly for dashboard's "last session" command)

return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/",
		options = { "buffers", "curdir", "tabpages", "winsize" },
	},

	config = function()
    local persistence = require("persistence")
    persistence.setup({})

    -- Keybindings
		-- load the session for the current directory
		vim.keymap.set("n", "<leader>ps", function()
			require("persistence").load()
		end, { desc = "Load session for current dir" })

		-- select a session to load
		vim.keymap.set("n", "<leader>pS", function()
			require("persistence").select()
		end, { desc = "Select a session to load" })

		-- load the last session
		vim.keymap.set("n", "<leader>pl", function()
			require("persistence").load({ last = true })
		end, { desc = "Load last session" })

		-- stop Persistence (session won't be saved on exit)
		vim.keymap.set("n", "<leader>pq", function()
			require("persistence").stop()
		end, { desc = "Stop persistence" })
	end,
}
