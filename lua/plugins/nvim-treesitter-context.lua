-- Show code context (surrounding functions and stuff) with treesitter
return {
	"nvim-treesitter/nvim-treesitter-context",

	config = function()
		require("treesitter-context").setup({
			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
			multiwindow = true, -- Enable multiwindow support.
			max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			line_numbers = true,
			multiline_threshold = 20, -- Maximum number of lines to show for a single context
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20, -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		})

		----- [[ Change highlight group ]] -----
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "TelescopeSelection" })

		----- [[ Keymaps ]] -----
		-- Jump to context (top)
		vim.keymap.set("n", "<A-c>", function()
			require("treesitter-context").go_to_context(vim.v.count1)
		end, { desc = "Jump to context", silent = true })

		-- Toggle context
		vim.keymap.set("n", "<leader>ct", function()
			require("treesitter-context").toggle()
		end, { desc = "Context toggle", silent = true })

		----- [[ Autocmds ]] -----
		----- [[ Set winblend only on treesitter-context floating window ]] -----
		-- The plugin uses noautocmd=true, so we detect the float via vim.w.treesitter_context.
		-- Must re-apply on every BufEnter/CursorMoved because the plugin recreates the float window.
		local function set_winblend()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.w[win].treesitter_context then
					vim.wo[win].winblend = 75
					return
				end
			end
		end
		-- Try on next event loop tick
		vim.schedule(set_winblend)
		-- Re-apply whenever the buffer is entered or cursor moves
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" }, {
			callback = set_winblend,
		})
	end,
}
