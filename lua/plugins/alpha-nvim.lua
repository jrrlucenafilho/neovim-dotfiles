-- Greeter
return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Load the custom header table once
		local custom_header = require("ui.headers.header_zooey_title_dragons")

		-- Change padding
		dashboard.config.layout = {
			{ type = "padding", val = 1 },
			dashboard.section.header,
			{ type = "padding", val = 0 },
			dashboard.section.buttons,
		}

		-- Overwrite the header section's content (val)
		dashboard.section.header.val = custom_header.val

		-- Overwrite the header section's options (opts) (for coloring)
		dashboard.section.header.opts = custom_header.opts

		-- Pass the type (text)
		dashboard.section.header.type = custom_header.type

		-- Dashboard buttons
		dashboard.section.buttons.val = {

			--Zoxide
			dashboard.button("z", "󰓩  Zoxide", "<cmd>Telescope zoxide list<CR>"),

			-- Yazi
			dashboard.button("y", "󰉋  Yazi", "<cmd>Yazi<CR>"),

			-- New file
			dashboard.button("n", "  New file", "<cmd>ene<CR>"),

			-- Find file
			dashboard.button("ff", "󰈞  Find file", "<cmd>lua require('telescope.builtin').find_files()<CR>"),

			-- Recently opened files
			dashboard.button(
				"r",
				"󰈚  Recently opened files",
				"<cmd>lua require('telescope.builtin').oldfiles()<CR>"
			),

			-- Frecency / MRU (telescope-frecency)
			dashboard.button(
				"fr",
				"󰄉  Frecency / MRU",
				"<cmd>lua require('telescope').extensions.frecency.frecency()<CR>"
			),

			-- Find word
			dashboard.button(
				"lg",
				"󰈬  Find word / Live grep",
				"<cmd>lua require('telescope.builtin').live_grep()<CR>"
			),

			-- Jump to bookmarks (Telescope marks)
			dashboard.button("b", "󰃀  Jump to bookmarks", "<cmd>lua require('telescope.builtin').marks()<CR>"),

			-- Open session menu
			dashboard.button("ss", "  Open session selection", "<cmd>lua require('persistence').select()<CR>"),

			-- Open last session (persistence.nvim)
			dashboard.button(
				"ls",
				"󰁯  Open last session",
				"<cmd>lua require('persistence').load({ last = true })<CR>"
			),

			-- Quit
			dashboard.button("q", "󰅖  Quit", "<cmd>qa<CR>"),
		}

		-- Finally, set it up
		alpha.setup(dashboard.config)

		-- Autocmds to hide bufferline when alpha is open
		-- Close Alpha before session restore
		vim.api.nvim_create_autocmd("User", {
			pattern = "PersistenceLoadPre",
			callback = function()
				pcall(vim.cmd, "AlphaClose")
			end,
		})

		-- Restore UI after session restore
		vim.api.nvim_create_autocmd("User", {
			pattern = "PersistenceLoadPost",
			callback = function()
				vim.o.showtabline = 2
				vim.o.laststatus = 3
				pcall(vim.cmd, "BufferLineShow")
			end,
		})

		-- Restore UI when Alpha is closed manually
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaClosed",
			callback = function()
				vim.o.showtabline = 2
				vim.o.laststatus = 3
				pcall(vim.cmd, "BufferLineShow")
			end,
		})

		-- Hide bufferline UI only while Alpha is active
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.o.showtabline = 0
				vim.o.laststatus = 0
				pcall(vim.cmd, "BufferLineHide")
			end,
		})

		-- Keybindings
		vim.keymap.set("n", "<leader>a", "<cmd>Alpha<CR>", { desc = "Open Alpha" })
	end,
}
