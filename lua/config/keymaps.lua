-- Miscellaneous keymaps
-- Not specifically related to any plugin

----- [[ Helper Functions ]] -----

-- Toggle column numbers among relative and absolute
local function toggle_number_column()
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
vim.keymap.set("n", "<leader>ms", "m", { desc = "Set mark (bookmark)" })

-- Open a bookmark
vim.keymap.set("n", "<leader>ml", "<cmd>lua require('telescope.builtin').marks()<CR>", { desc = "List bookmarks" })

-- List bookmarks only for current buffer
vim.keymap.set("n", "<leader>mb", function()
	local marks = vim.fn.getmarklist(0)
	local lines = {}
	for _, mark in ipairs(marks) do
		if mark.mark:match("^[a-z]$") then
			local lnum = mark.pos[2]
			local text = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
			table.insert(lines, string.format("'%s  line %d: %s", mark.mark, lnum, text))
		end
	end
	if #lines == 0 then
		print("No buffer-local marks set.")
		return
	end
	vim.lsp.util.open_floating_preview(lines, "markdown", { border = "single" })
end, { desc = "Show buffer-local marks" })

-- Copying/pasting to system clipboard commands for neovide
if vim.g.neovide == true then
	-- Copy current line
	vim.keymap.set({ "n" }, "<C-C>", '"+yy', { desc = "Copy current line to system clipboard" })

	-- Copy visual selection
	vim.keymap.set({ "v" }, "<C-C>", '"+y', { desc = "Copy visual selection to system clipboard" })

	-- Paste (normal and visual modes)
	vim.keymap.set({ "n", "v" }, "<C-V>", '"+p', { desc = "Paste from system clipboard" })
end

-- Copy range of lines (write "start_line end_line")
vim.keymap.set("n", "yr", function()
	toggle_number_column()
	vim.defer_fn(function()
		vim.ui.input({ prompt = "Yank Range: " }, function(input)
			if input and input ~= "" then
				local start_line, end_line = input:match("(%d+)%s+(%d+)")
				if start_line and end_line then
					vim.cmd("silent " .. start_line .. "," .. end_line .. "y+")
				end
			end
			toggle_number_column()
		end)
	end, 100)
end, { desc = "Copy range to system clipboard" })

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

-- Show buffer-local marks only
vim.keymap.set("n", "<leader>mb", function()
	local lines = {}
	for i = string.byte("a"), string.byte("z") do
		local mark = string.char(i)
		local pos = vim.fn.getpos("'" .. mark)
		if pos[2] ~= 0 then -- mark exists and is in current buffer
			local lnum = pos[2]
			local text = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
			table.insert(lines, string.format("'%s  line %d: %s", mark, lnum, text))
		end
	end
	if #lines == 0 then
		print("No buffer-local marks set.")
		return
	end
	vim.lsp.util.open_floating_preview(lines, "markdown", { border = "single" })
end, { desc = "Show buffer-local marks" })

-- Toggle between relative number column and vice versa
vim.keymap.set("n", "<leader>nc", toggle_number_column, { desc = "Toggle relative number column" })
