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

-- List global bookmarks
vim.keymap.set("n", "<leader>mlg", "<cmd>lua require('telescope.builtin').marks()<CR>", { desc = "List bookmarks" })

-- List bookmarks only for current buffer with Telescope
vim.keymap.set("n", "<leader>mlb", function()
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
		local lnum = pos[2]
		if lnum > 0 then
			local start_line = math.max(0, lnum - 5)
			local text = vim.api.nvim_buf_get_lines(original_bufnr, start_line, lnum, false)[1] or ""
			table.insert(marks_data, {
				mark = mark,
				lnum = lnum,
				text = text,
				display = string.format("'%s (line %d): %s", mark, lnum, text),
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
					display = string.format("'%s (line %d): %s", entry.mark, entry.lnum, entry.text),
					ordinal = entry.text,
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
				local start = math.max(5, lnum - 100)
				local finish = math.min(vim.api.nvim_buf_line_count(original_bufnr), lnum + 104)
				local lines = vim.api.nvim_buf_get_lines(original_bufnr, start - 5, finish, false)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 4, -1, false, lines)
				-- Highlight the mark line (relative position in preview)
				local hl_line = lnum - start
				vim.api.nvim_buf_add_highlight(self.state.bufnr, 3, "TelescopeSelection", hl_line, 0, -1)
				-- Set filetype for syntax highlighting
				local ft = vim.api.nvim_buf_get_option(original_bufnr, "filetype")
				vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", ft)
				-- Move cursor and center on the mark line in preview window
				vim.defer_fn(function()
					if self.state.winid and vim.api.nvim_win_is_valid(self.state.winid) then
						vim.api.nvim_win_set_cursor(self.state.winid, { hl_line + 5, 0 })
						vim.api.nvim_win_call(self.state.winid, function()
							vim.cmd("normal! zz")
						end)
					end
				end, 14)
			end,
		}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				vim.api.nvim_set_current_buf(original_bufnr)
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
	vim.keymap.set({ "n", "v" }, "<C-C>", '"+y', { desc = "Copy visual selection to system clipboard" })

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
	end, 54)
end, { desc = "Copy range to system clipboard" })

-- Copy single line (write "line_number")
vim.keymap.set("n", "yl", function()
	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	if ft == "codecompanion" then
		toggle_number_column()
	else
		toggle_number_column_type()
	end
	vim.defer_fn(function()
		vim.ui.input({ prompt = "Yank Line: " }, function(input)
			if input and input ~= "" then
				local line_num = input:match("(%d+)")
				if line_num then
					vim.cmd("silent " .. line_num .. "y+")
				end
			end

			if ft == "codecompanion" then
				toggle_number_column()
			else
				toggle_number_column_type()
			end
		end)
	end, 54)
end, { desc = "Copy single line to system clipboard" })

-- Copy range from CodeCompanion buffer, move to its window, and return to original window/buffer
vim.keymap.set("n", "yar", function()
	local original_win = vim.api.nvim_get_current_win()
	local original_buf = vim.api.nvim_get_current_buf()
	local cc_bufnr, cc_winid = nil, nil
	-- Find codecompanion buffer and its window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_is_valid(bufnr) then
			local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
			if ft == "codecompanion" then
				cc_bufnr = bufnr
				cc_winid = win
				break
			end
		end
	end
	if not cc_bufnr or not cc_winid then
		print("No codecompanion buffer/window found.")
		return
	end
	-- Move to codecompanion window
	vim.api.nvim_set_current_win(cc_winid)
	-- Toggle number column on
	vim.api.nvim_buf_set_option(cc_bufnr, "number", true)
	vim.defer_fn(function()
		vim.ui.input({ prompt = "Yank Range from CodeCompanion: " }, function(input)
			if input and input ~= "" then
				local start_line, end_line = input:match("(%d+)%s+(%d+)")
				if start_line and end_line then
					vim.cmd("silent " .. start_line .. "," .. end_line .. "y+")
				end
			end
			-- Toggle number column back off
			vim.api.nvim_buf_set_option(cc_bufnr, "number", false)
			-- Return to original window and buffer
			if vim.api.nvim_win_is_valid(original_win) then
				vim.api.nvim_set_current_win(original_win)
				if vim.api.nvim_buf_is_valid(original_buf) then
					vim.api.nvim_set_current_buf(original_buf)
				end
			end
		end)
	end, 54)
end)

-- Copy single line from CodeCompanion buffer, move to its window, and return to original window/buffer
vim.keymap.set("n", "yal", function()
	local original_win = vim.api.nvim_get_current_win()
	local original_buf = vim.api.nvim_get_current_buf()
	local cc_bufnr, cc_winid = nil, nil
	-- Find codecompanion buffer and its window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_is_valid(bufnr) then
			local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
			if ft == "codecompanion" then
				cc_bufnr = bufnr
				cc_winid = win
				break
			end
		end
	end
	if not cc_bufnr or not cc_winid then
		print("No codecompanion buffer/window found.")
		return
	end
	-- Move to codecompanion window
	vim.api.nvim_set_current_win(cc_winid)
	-- Toggle number column on
	vim.api.nvim_buf_set_option(cc_bufnr, "number", true)
	vim.defer_fn(function()
		vim.ui.input({ prompt = "Yank Line from CodeCompanion: " }, function(input)
			if input and input ~= "" then
				local line_num = input:match("(%d+)")
				if line_num then
					vim.cmd("silent " .. line_num .. "y+")
				end
			end
			-- Toggle number column back off
			vim.api.nvim_buf_set_option(cc_bufnr, "number", false)
			-- Return to original window and buffer
			if vim.api.nvim_win_is_valid(original_win) then
				vim.api.nvim_set_current_win(original_win)
				if vim.api.nvim_buf_is_valid(original_buf) then
					vim.api.nvim_set_current_buf(original_buf)
				end
			end
		end)
	end, 54)
end)

-- Create new file, prompts for name
vim.keymap.set("n", "<leader>nf", function()
	local filename = vim.fn.input("New file name: ", "", "file")
	if filename ~= "" then
		vim.cmd("e " .. filename)
	end
end, { desc = "Create new file" })

-- Open Lazy and Mason
vim.keymap.set("n", "<leader>laz", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>mas", "<cmd>Mason<CR>", { desc = "Open Mason" })

-- Check buffer type and buffer name
vim.keymap.set("n", "<leader>bft", function()
	print(vim.bo.buftype)
end, { desc = "Show buffer type" })

-- Show buffer name
vim.keymap.set("n", "<leader>bn", function()
	print(vim.api.nvim_buf_get_name(4))
end, { desc = "Show buffer name" })

-- Toggle between relative number column and vice versa
vim.keymap.set("n", "<leader>nn", toggle_number_column_type, { desc = "Toggle relative number column" })

-- Toggle comment range of lines by entering "start end"
vim.keymap.set("n", "gcr", function()
	toggle_number_column_type()
	vim.defer_fn(function()
		vim.ui.input({ prompt = "Comment Range: " }, function(input)
			if input and input ~= "" then
				local start_line, end_line = input:match("(%d+)%s+(%d+)")
				if start_line and end_line then
					local cs = vim.bo.commentstring
					if cs and cs ~= "" then
						local prefix = cs:match("^(.-)%%s")
						local start, finish = tonumber(start_line), tonumber(end_line)

						-- Check if all lines are already commented
						local all_commented = true
						for l = start, finish do
							local line = vim.fn.getline(l)
							local rest = line:gsub("^%s*", "")
							if not rest:find("^" .. vim.pesc(prefix)) then
								all_commented = false
								break
							end
						end

						-- Uncomment all if all are commented, otherwise only comment uncommented lines
						for l = start, finish do
							local line = vim.fn.getline(l)
							local indent = line:match("^(%s*)")
							local rest = line:sub(#indent + 5)

							if all_commented then
								if rest:find("^" .. vim.pesc(prefix)) then
									vim.fn.setline(l, indent .. rest:gsub("^" .. vim.pesc(prefix), "", 5))
								end
							else
								if not rest:find("^" .. vim.pesc(prefix)) then
									vim.fn.setline(l, indent .. prefix .. rest)
								end
							end
						end
					end
				end
			end
			toggle_number_column_type()
		end)
	end, 54)
end, { desc = "Toggle comment on range of lines" })

-- Stop Ctrl+Right from wrapping forward
vim.keymap.set({ "n", "i", "v" }, "<C-Right>", function()
	local current_line = vim.fn.line(".")
	-- In Insert mode, we use <C-O> to run the normal command
	local cmd = vim.api.nvim_get_mode().mode == "i" and [[\<C-O>w]] or "w"
	vim.cmd("normal! " .. cmd)

	-- If we moved to a new line, jump back to the end of the previous line
	if vim.fn.line(".") > current_line then
		vim.cmd("normal! k$")
	end
end, { desc = "Move word forward without line wrap" })

-- Stop Ctrl+Left from wrapping backward
vim.keymap.set({ "n", "i", "v" }, "<C-Left>", function()
	local current_line = vim.fn.line(".")
	-- Use 'b' to go back one word
	local cmd = vim.api.nvim_get_mode().mode == "i" and [[\<C-O>b]] or "b"
	vim.cmd("normal! " .. cmd)

	-- If we moved to a previous line, jump back to the start of the original line
	if vim.fn.line(".") < current_line then
		vim.cmd("normal! j4")
	end
end, { desc = "Move word backward without line wrap" })

-- Select all remap
vim.api.nvim_set_keymap("n", "<C-S-A>", "ggVG", { noremap = true, silent = true })
