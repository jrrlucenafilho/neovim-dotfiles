-- Session manager
-- (mainly for dashboard's "last session" command)

return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened

	config = function()
		local persistence = require("persistence")

		persistence.setup({
			dir = vim.fn.stdpath("state") .. "/sessions/",
			options = { "buffers", "curdir", "tabpages", "winsize" },
		})

		-- Autocmd for closing neotree when returning to a session, if it's open
		vim.api.nvim_create_autocmd("User", {
			pattern = "PersistenceLoadPost",
			callback = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local ft = vim.bo[buf].filetype
					local name = vim.api.nvim_buf_get_name(buf)

					if ft == "neo-tree" or name:match("neo%-tree") then
						pcall(vim.api.nvim_buf_delete, buf, { force = true })
					end
				end
			end,
		})

		-- Keybindings
		-- load the session for the current directory
		vim.keymap.set("n", "<leader>ps", function()
			persistence.load()
		end, { desc = "Load session for current dir" })

		-- select a session to load
		vim.keymap.set("n", "<leader>pS", function()
			persistence.select()
		end, { desc = "Select a session to load" })

		-- load the last session
		vim.keymap.set("n", "<leader>pl", function()
			persistence.load({ last = true })
		end, { desc = "Load last session" })

		-- stop Persistence (session won't be saved on exit)
		vim.keymap.set("n", "<leader>pq", function()
			persistence.stop()
		end, { desc = "Stop persistence" })
	end,
}
