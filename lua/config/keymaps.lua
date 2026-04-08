-- Miscellaneous keymaps
-- Not specifically related to any plugin

----- [[ Helper Funtctions ]] -----

-- Toggle column numbers among relative and absolute
local function toggle_relative_number()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
	else
		vim.wo.relativenumber = true
	end
end

----- [[ Keymaps ]] -----

-- LazyVim's buffer closing function
local buf_remove = require("utils.bufremove")
vim.keymap.set("n", "<A-q>", buf_remove.bufremove, { desc = "Delete buffer" })

-- Quick save
vim.keymap.set("n", "<A-s>", ":w<CR>", { desc = "Quick save" })

-- Stop search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Open at-cursor diagnostics
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.open_float({
		focus = false,
		scope = "cursor",
	})
end, { desc = "Cursor diagnostics" })

-- Open at-line diagnostics
vim.keymap.set("n", "<leader>dl", function()
	vim.diagnostic.open_float({
		focus = false,
		scope = "line",
	})
end, { desc = "Line diagnostics" })

-- Bookmarking
-- Create a bookmark
-- Lowercase: local bookmark
-- Uppercase: global bookmark (survives file switches)
vim.keymap.set("n", "<leader>bs", "m", { desc = "Set mark (bookmark)" })

-- Open a bookmark
vim.keymap.set("n", "<leader>bo", "<cmd>lua require('telescope.builtin').marks()<CR>", { desc = "Open bookmarks" })

-- Copying/pasting to system clipboard commands for neovide
if vim.g.neovide == true then
	-- Copy current line
	vim.keymap.set({ "n" }, "<C-C>", '"+yy', { desc = "Copy current line to system clipboard" })
	-- Copy visual selection
	vim.keymap.set({ "v" }, "<C-C>", '"+y', { desc = "Copy visual selection to system clipboard" })

	-- Copy range of lines
	vim.keymap.set("n", "yr", function()
		toggle_relative_number()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<C-u>y+<Left><Left>", true, false, true), "m", false)
		vim.schedule(toggle_relative_number)
	end, { desc = "Copy range to system clipboard" })
	-- Paste (normal and visual modes)
	vim.keymap.set({ "n", "v" }, "<C-V>", '"+p', { desc = "Paste from system clipboard" })
end

-- Create new file, prompts for name
vim.keymap.set("n", "<leader>nf", function()
	local filename = vim.fn.input("New file name: ", "", "file")
	if filename ~= "" then
		vim.cmd("e " .. filename)
	end
end, { desc = "Create new file" })

-- Open Lazy and Mason
vim.keymap.set("n", "<leader>la", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>ma", "<cmd>Mason<CR>", { desc = "Open Mason" })

-- Check buffer type and buffer name
vim.keymap.set("n", "<leader>bt", function()
	print(vim.bo.buftype)
end, { desc = "Show buffer type" })

-- Show buffer name
vim.keymap.set("n", "<leader>bn", function()
	print(vim.api.nvim_buf_get_name(0))
end, { desc = "Show buffer name" })

-- Toggle between relative number column and vice versa
vim.keymap.set("n", "<leader>cn", toggle_relative_number, { desc = "Toggle relative number column" })
