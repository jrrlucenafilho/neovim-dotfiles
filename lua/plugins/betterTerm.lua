-- Integrated terminal
return {
	"CRAG666/betterTerm.nvim",
	opts = {},

	config = function()
		local betterTerm = require("betterTerm")

		betterTerm.setup({
			prefix = "Term",
			position = "bot",
			size = math.floor(vim.o.lines / 2.5),
			startInserted = true,
			show_tabs = true,
			new_tab_mapping = "<C-t>",
			jump_tab_mapping = "<C-$tab>",
			active_tab_hl = "TabLineSel",
			inactive_tab_hl = "TabLine",
			new_tab_hl = "BetterTermSymbol",
			new_tab_icon = "+",
			index_base = 0,
		})

		-- Keybindings
		-- Toggle the first terminal (ID defaults to index_base, which is 0)
		vim.keymap.set({ "n", "t" }, "<C-'>", function()
			betterTerm.open()
		end, { desc = "Toggle terminal 0" })

		-- Open terminal 1
		vim.keymap.set({ "n", "t" }, "<C-/>", function()
	    betterTerm.open(1)
		end, { desc = "Toggle terminal 1" })

		-- Open terminal 2
		vim.keymap.set({ "n", "t" }, "<C-;>", function()
	    betterTerm.open(2)
		end, { desc = "Toggle terminal 2" })

		-- Select a terminal to focus
		vim.keymap.set("n", "<leader>tt", betterTerm.select, { desc = "Select terminal" })

		-- Rename the current terminal
		vim.keymap.set("n", "<leader>tr", betterTerm.rename, { desc = "Rename terminal" })

		-- Toggle the tabs bar
		vim.keymap.set("n", "<leader>tb", betterTerm.toggle_tabs, { desc = "Toggle terminal tabs" })
	end,
}
