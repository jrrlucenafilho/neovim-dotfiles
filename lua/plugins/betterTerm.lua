-- Integrated terminal
return {
	"CRAG666/betterTerm.nvim",
	opts = {},

	config = function()
		local betterTerm = require("betterTerm")

		local original_size = math.floor(vim.o.lines / 2.5)
		local large_size = math.floor(vim.o.lines * 0.8)
		local is_large = false

		betterTerm.setup({
			prefix = "Term",
			position = "bot",
			size = original_size,
			startInserted = true,
			show_tabs = true,
			new_tab_mapping = "<A-t>",
			jump_tab_mapping = "<C-$tab>",
			active_tab_hl = "TabLineSel",
			inactive_tab_hl = "TabLine",
			new_tab_hl = "BetterTermSymbol",
			new_tab_icon = "+",
			index_base = 1,
		})

		----- [[ Helper Functions ]] -----
		-- Toggle terminal size between original and large
		local function toggle_betterterm_size()
			local found = false
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local name = vim.api.nvim_buf_get_name(buf)
				if name:find("Term %(") then
					vim.api.nvim_set_current_win(win)
					if is_large then
						vim.cmd("resize " .. original_size)
						is_large = false
					else
						vim.cmd("resize " .. large_size)
						is_large = true
					end
					found = true
					break
				end
			end
			if not found then
				-- No BetterTerm terminal open, do nothing
				return
			end
		end

		-- [[ Keymaps ]] --
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

		-- Toggle BetterTerm size with 'be' in normal mode
		vim.keymap.set({ "n" }, "<leader>eb", toggle_betterterm_size, { desc = "Toggle terminal expansion" })

		-- Select a terminal to focus
		vim.keymap.set("n", "<leader>ts", betterTerm.select, { desc = "Select terminal" })

		-- Rename the current terminal (for now renaming shoudln't be done if i plan on closing the renamed terminal)
		vim.keymap.set({ "n", "t" }, "<A-r>", betterTerm.rename, { desc = "Rename terminal" })

		-- Toggle the terminal window
		vim.keymap.set({ "n", "t" }, "<A-'>", betterTerm.toggle_termwindow, { desc = "Toggle terminal tabs" })

		-- Close the currently opened terminal (it's just bwipeout! for terminal mode only)
		vim.keymap.set({ "t" }, "<A-q>", "<cmd>bwipeout!<cr>", { desc = "Close current terminal" })

		-- Cycling among terminals
		vim.keymap.set({ "t" }, "<A-Right>", function()
			betterTerm.cycle(1)
		end, { desc = "Cycle to next terminal" })
		vim.keymap.set({ "t" }, "<A-l>", function()
			betterTerm.cycle(1)
		end, { desc = "Cycle to next terminal" })

		vim.keymap.set({ "t" }, "<A-Left>", function()
			betterTerm.cycle(-1)
		end, { desc = "Cycle to previous terminal" })
		vim.keymap.set({ "t" }, "<A-h>", function()
			betterTerm.cycle(-1)
		end, { desc = "Cycle to previous terminal" })
	end,

	-- Make 'esc' quit terminal mode
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>"),
}
