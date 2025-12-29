-- Miscellaneous keymaps
-- Not specifically related to any plugin

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

-- Bookmarking
-- Create a bookmark
-- Lowercase: local bookmark
-- Uppercase: global bookmark (survives file switches)
vim.keymap.set("n", "<leader>bm", "m", { desc = "Set mark (bookmark)" })

-- Open a bookmark
vim.keymap.set("n", "<leader>bo", "<cmd>lua require('telescope.builtin').marks()<CR>", { desc = "Open bookmarks" })

-- Copying/pasting to system clipboard commands for neovide
if vim.g.neovide == true then
	-- Copy current line
	vim.keymap.set({ "n" }, "<C-S-C>", '"+yy', { desc = "Copy current line to system clipboard" })
	-- Copy visual selection
	vim.keymap.set({ "v" }, "<C-S-C>", '"+y', { desc = "Copy visual selection to system clipboard" })
	-- Copy range of lines
	vim.keymap.set("n", "<C-S-R>", ":<C-u>y+<left><left>", { desc = "Copy range to system clipboard" })

	-- Paste (normal and visual modes)
	vim.keymap.set({ "n", "v" }, "<C-S-V>", '"+p', { desc = "Paste from system clipboard" })
end

-- Create new file, prompts for name
vim.keymap.set("n", "<leader>n", function()
	local filename = vim.fn.input("New file name: ", "", "file")
	if filename ~= "" then
		vim.cmd("e " .. filename)
	end
end, { desc = "Create new file" })
