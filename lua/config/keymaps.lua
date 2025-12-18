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
vim.keymap.set("n", "<leader>d", function()
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

-- Open Frecency / MRU
vim.keymap.set("n", "<leader>fr", function()
	require("telescope").load_extension("frecency")
	require("telescope").extensions.frecency.frecency()
end, { desc = "Open Frecency / MRU" })
