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
		-- Open terminal 1
		vim.keymap.set({ "n", "t" }, "<A-1>", function()
			betterTerm.open(1)
		end, { desc = "Toggle terminal 1" })

		-- Open terminal 2
		vim.keymap.set({ "n", "t" }, "<A-2>", function()
			betterTerm.open(2)
		end, { desc = "Toggle terminal 2" })

		-- Open terminal 3
		vim.keymap.set({ "n", "t" }, "<A-3>", function()
			betterTerm.open(3)
		end, { desc = "Toggle terminal 3" })

		-- Open terminal 4
		vim.keymap.set({ "n", "t" }, "<A-4>", function()
			betterTerm.open(4)
		end, { desc = "Toggle terminal 4" })

		-- Open terminal 5
		vim.keymap.set({ "n", "t" }, "<A-5>", function()
			betterTerm.open(5)
		end, { desc = "Toggle terminal 5" })

		-- Open terminal 6
		vim.keymap.set({ "n", "t" }, "<A-6>", function()
			betterTerm.open(6)
		end, { desc = "Toggle terminal 6" })

		-- Open terminal 7
		vim.keymap.set({ "n", "t" }, "<A-7>", function()
			betterTerm.open(7)
		end, { desc = "Toggle terminal 7" })

		-- Open terminal 8
		vim.keymap.set({ "n", "t" }, "<A-8>", function()
			betterTerm.open(8)
		end, { desc = "Toggle terminal 8" })

		-- Open terminal 9
		vim.keymap.set({ "n", "t" }, "<A-9>", function()
			betterTerm.open(9)
		end, { desc = "Toggle terminal 9" })

		-- Open terminal 0
		vim.keymap.set({ "n", "t" }, "<A-0>", function()
			betterTerm.open(0)
		end, { desc = "Toggle terminal 0" })

		-- Select a terminal to focus
		vim.keymap.set("n", "<leader>ts", betterTerm.select, { desc = "Select terminal" })

		-- Rename the current terminal
		vim.keymap.set({ "n", "t" }, "<A-r>", betterTerm.rename, { desc = "Rename terminal" })

		-- Toggle the terminal window
		vim.keymap.set({ "n", "t" }, "<A-t>", betterTerm.toggle_termwindow, { desc = "Toggle terminal tabs" })

		-- Close the currently opened terminal (it's just bd! for terminal mode only
		vim.keymap.set({ "t" }, "<A-c>", "<cmd>bd!<cr>", { desc = "Close current terminal" })
	end,
}
