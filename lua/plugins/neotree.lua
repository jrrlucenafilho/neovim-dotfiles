return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{ -- For LSP-enhanced filenames
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-neo-tree/neo-tree.nvim",
			},
			config = function()
				require("lsp-file-operations").setup()
			end,
		},
		{ -- For _with_window_picker keymaps
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify", "Outline", "codecompanion" },
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			window = {
				width = 30,
				mappings = {
					["R"] = "refresh",
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
							use_image_nvim = true,
						},
					},
				},
				filters = {
					filetype = { "codecompanion" }, -- don't open files in codecompanion windows
				},
				get_target_window = function(state, path) -- ignores codecompanion window when opening files
					local wins = vim.api.nvim_list_wins()
					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)
						local ft = vim.api.nvim_buf_get_option(buf, "filetype")
						if ft ~= "neo-tree" and ft ~= "codecompanion" then
							if vim.api.nvim_buf_get_name(buf) == path then
								return win
							end
						end
					end
					return nil
				end,
			},
		})

		----- [[ Keymaps ]] -----
		-- Toggle neotree on the left
		vim.keymap.set({ "n" }, "<C-t>", "<cmd>Neotree toggle left<cr>", { desc = "Neotree toggle left" })

		-- Toggle Neo-tree window width between 30 and 60 columns
		local function toggle_neotree_width()
			local target_widths = { 30, 60 }
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_buf_get_option(buf, "filetype")
				if ft == "neo-tree" then
					local cur_width = vim.api.nvim_win_get_width(win)
					local new_width = target_widths[1]
					if math.abs(cur_width - target_widths[1]) < 2 then
						new_width = target_widths[2]
					end
					vim.api.nvim_win_set_width(win, new_width)
					break
				end
			end
		end
		vim.keymap.set("n", "<leader>te", toggle_neotree_width, { desc = "Toggle Neo-tree window width" })

		-- Function for git status picker
		local function neotree_git_status_picker()
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local Job = require("plenary.job")
			Job:new({
				command = "git",
				args = { "branch", "--format=%(refname:short)" },
				on_exit = function(j)
					local branches = j:result()
					vim.schedule(function()
						pickers
							.new({}, {
								prompt_title = "Git base branch",
								finder = finders.new_table({ results = branches }),
								sorter = conf.generic_sorter({}),
								attach_mappings = function(prompt_bufnr, map)
									actions.select_default:replace(function()
										actions.close(prompt_bufnr)
										local selection = action_state.get_selected_entry()
										if selection and selection[1] then
											vim.cmd("Neotree float git_status git_base=" .. selection[1])
										end
									end)
									return true
								end,
							})
							:find()
					end)
				end,
			}):start()
		end

		-- Get git file status
		vim.keymap.set(
			"n",
			"<leader>gs",
			neotree_git_status_picker,
			{ desc = "Neo-tree Git Status (pick base branch)" }
		)

		-- Reveal current file in neotree
		vim.keymap.set("n", "<leader>cf", "<cmd>Neotree reveal<cr>", { desc = "Open Neo-tree in current file" })

		----- [[ Autocmds ]] -----
		-- Refresh neotree on each commit and push
		vim.api.nvim_create_autocmd("User", {
			pattern = { "NeogitCommitComplete", "NeogitPushComplete" },
			callback = function()
				require("neo-tree.sources.manager").refresh("filesystem")
			end,
		})
	end,
}
