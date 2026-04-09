-- Miscellaneous keymaps
-- Not specifically related to any plugin

----- [[ Helper Functions ]] -----
-- Toggle column numbers among relative and absolute
local function toggle_number_column_type()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
	else
		vim.wo.relativenumber = true
	end
end

-- Toggle the number column itself
local function toggle_number_column()
	vim.wo.number = not vim.wo.number
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
vim.keymap.set("n", "<leader>mg", "<cmd>lua require('telescope.builtin').marks()<CR>", { desc = "List bookmarks" })

-- List bookmarks only for current buffer with Telescope
vim.keymap.set("n", "<leader>mb", function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	-- Store the original buffer before creating picker
	local original_bufnr = vim.api.nvim_get_current_buf()

	-- Collect buffer-local marks
	local marks_data = {}
	for i = string.byte("a"), string.byte("z") do
		local mark = string.char(i)
		local pos = vim.fn.getpos("'" .. mark)
		if pos[2] ~= 0 then
			local lnum = pos[2]
			local text = vim.api.nvim_buf_get_lines(original_bufnr, lnum - 1, lnum, false)[1] or ""
			table.insert(marks_data, {
				mark = mark,
				lnum = lnum,
				text = text,
				display = string.format("'%s: %s", mark, text),
			})
		end
	end

	if #marks_data == 0 then
		print("No buffer-local marks set.")
		return
	end

	-- Create custom picker
	local picker = pickers.new({}, {
		prompt_title = "Buffer Marks",
		finder = finders.new_table({
			results = marks_data,
			entry_maker = function(entry)
				return {
					value = entry,
					display = string.format("'%s: %s", entry.mark, entry.text),
					ordinal = entry.mark,
				}
			end,
		}),
		sorter = conf.generic_sorter({}),
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				width = 0.95,
				height = 0.95,
				preview_width = 0.6,
			},
		},
		previewer = require("telescope.previewers").new_buffer_previewer({
			define_preview = function(self, entry)
				local lnum = entry.value.lnum
				local start = math.max(1, lnum - 100)
				local finish = math.min(vim.api.nvim_buf_line_count(original_bufnr), lnum + 100)
				local lines = vim.api.nvim_buf_get_lines(original_bufnr, start - 1, finish, false)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				-- Highlight the mark line (relative position in preview)
				local hl_line = lnum - start
				vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Search", hl_line, 0, -1)
				-- Set filetype for syntax highlighting
				local ft = vim.api.nvim_buf_get_option(original_bufnr, "filetype")
				vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", ft)
				-- Move cursor and center on the mark line in preview window
				vim.defer_fn(function()
					if self.state.winid and vim.api.nvim_win_is_valid(self.state.winid) then
						vim.api.nvim_win_set_cursor(self.state.winid, { hl_line + 1, 0 })
						vim.api.nvim_win_call(self.state.winid, function()
							vim.cmd("normal! zz")
						end)
					end
				end, 10)
			end,
		}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				vim.api.nvim_win_set_cursor(0, { entry.value.lnum, 0 })
			end)
			map("i", "<C-j>", actions.move_selection_next)
			map("i", "<C-k>", actions.move_selection_previous)
			return true
		end,
	})
	picker:find()
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
	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	if ft == "codecompanion" then
		toggle_number_column()
	else
		toggle_number_column_type()
	end
	vim.defer_fn(function()
		vim.ui.input({ prompt = "Yank Range: " }, function(input)
			if input and input ~= "" then
				local start_line, end_line = input:match("(%d+)%s+(%d+)")
				if start_line and end_line then
					vim.cmd("silent " .. start_line .. "," .. end_line .. "y+")
				end
			end

			if ft == "codecompanion" then
				toggle_number_column()
			else
				toggle_number_column_type()
			end
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

-- Toggle between relative number column and vice versa
vim.keymap.set("n", "<leader>nc", toggle_number_column_type, { desc = "Toggle relative number column" })
