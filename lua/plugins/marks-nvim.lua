-- A better user experience for interacting with and manipulating Vim marks.
return {
	"chentoast/marks.nvim",
	event = "VeryLazy",

	config = function()
		require("marks").setup({
			-- whether to map keybinds or not. default true
			default_mappings = false,
			-- which builtin marks to show. default {}
			builtin_marks = { ".", "<", ">", "^" },
			-- whether movements cycle back to the beginning/end of buffer. default true
			cyclic = true,
			-- whether the shada file is updated after modifying uppercase marks. default false
			force_write_shada = false,
			-- how often (in ms) to redraw signs/recompute mark positions.
			-- higher values will have better performance but may cause visual lag,
			-- while lower values may cause performance penalties. default 150.
			refresh_interval = 250,
			-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
			-- marks, and bookmarks.
			-- can be either a table with all/none of the keys, or a single number, in which case
			-- the priority applies to all marks.
			-- default 10.
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			-- disables mark tracking for specific filetypes. default {}
			excluded_filetypes = { "neo-tree", "Outline", "dapui_watches" },
			-- disables mark tracking for specific buftypes. default {}
			excluded_buftypes = {},
			-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
			-- sign/virttext. Bookmarks can be used to group together positions and quickly move
			-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
			-- default virt_text is "",.
			bookmark_0 = {
				sign = "⚑",
				virt_text = "hello world",
				-- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
				-- defaults to false.
				annotate = false,
			},

			----- [[ Keymaps ]] ----
			mappings = {
				set = "m", -- Sets a letter mark (will wait for input).
				set_next = "<leader>ms", -- Set next available lowercase mark at cursor.
				toggle = "<leader>mt", -- Toggle next available mark at cursor.
				delete_line = "<leader>mdd", -- Deletes all marks on current line.
				delete_buf = "<leader>mdb", -- Deletes all marks in current buffer.
				next = "<leader>mn", -- Goes to next mark in buffer.
				prev = "<leader>mp", -- Goes to previous mark in buffer.
				preview = "<leader>mv", -- Previews mark (will wait for user input). press <cr> to just preview the next mark.
				delete = "<leader>mdl", -- Delete a letter mark (will wait for input).
				-- set_bookmark[0-9] = "",      -- Sets a bookmark from group[0-9].
				-- delete_bookmark[0-9] = "",   -- Deletes all bookmarks from group[0-9].
				-- delete_bookmark = "", -- Deletes the bookmark under the cursor.
				-- next_bookmark = "", -- Moves to the next bookmark having the same type as the bookmark under the cursor.
				-- prev_bookmark = "", -- Moves to the previous bookmark having the same type as the bookmark under the cursor.
				-- next_bookmark[0-9] = "",     -- Moves to the next bookmark of the same group type. Works by first going according to line number, and then according to buffer number.
				-- prev_bookmark[0-9] = "",     -- Moves to the previous bookmark of the same group type. Works by first going according to line number, and then according to buffer number.
				annotate = "<leader>maa",
			},
		})
	end,
}
