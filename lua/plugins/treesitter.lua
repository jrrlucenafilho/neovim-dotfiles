-- Responsible for code parsing
-- highlighting, better syntax, indentation and navigation
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	----- [[ Init ]]-----
	init = function()
		-- Enabling highlighting and indentation myself
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				-- Folding behavior (Disabled it in options, skip for codecompanion)
				if ev.match ~= "codecompanion" then
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
				end
			end,
		})

		-- Auto install uninstalled treesitter parsers if it detects a buffer with an available one that hasn't been installed (basically old auto_install)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match)
				local available_langs = require("nvim-treesitter").get_available()
				local is_available = vim.tbl_contains(available_langs, lang)
				if is_available then
					local installed_langs = require("nvim-treesitter").get_installed()
					local installed = vim.tbl_contains(installed_langs, lang)
					if not installed then
						require("nvim-treesitter").install(lang):wait()
					end
					vim.treesitter.start()
					require("nvim-treesitter").indentexpr()
				end
			end,
		})
		-- Making own 'ensureInstalled', add parsers here
		-- Available parsers: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
		local ensureInstalled = {
			"lua",
			"python",
			"typescript",
			"javascript",
			"c",
			"cpp",
			"rust",
			"html",
			"python",
			"java",
			"markdown",
			"markdown_inline",
			"yaml",
			"tsx",
			"jsx",
		}

		local alreadyInstalled = require("nvim-treesitter.config").get_installed()
		local parsersToInstall = vim.iter(ensureInstalled)
			:filter(function(parser)
				return not vim.tbl_contains(alreadyInstalled, parser)
			end)
			:totable()
		require("nvim-treesitter").install(parsersToInstall)

		-- Keymap to list installed parsers in Telescope with details
		vim.keymap.set("n", "<leader>tp", function()
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values

			local installed = require("nvim-treesitter.config").get_installed()
			local parsers_config = require("nvim-treesitter.parsers")

			-- Format parser details for display
			local function format_parser_details(lang)
				local config = parsers_config[lang]
				if not config then
					return string.format("Parser: %s\n\nNo configuration found.", lang)
				end

				local details = {}
				table.insert(details, string.format("┌─ Parser: %s", lang))
				table.insert(details, "│")
				if config.install_info then
					table.insert(details, string.format("│ Repository: %s", config.install_info.url or "N/A"))
					table.insert(
						details,
						string.format(
							"│ Revision:  %s",
							config.install_info.revision or config.install_info.branch or "N/A"
						)
					)
					if config.install_info.location then
						table.insert(details, string.format("│ Location:  %s", config.install_info.location or "N/A"))
					end
				end
				if config.maintainers then
					table.insert(
						details,
						string.format(
							"│ Maintainer%s: %s",
							#config.maintainers > 1 and "s" or "",
							table.concat(config.maintainers, ", ")
						)
					)
				end
				if config.tier then
					local tier_names = { [1] = "stable", [2] = "unstable", [3] = "unmaintained" }
					table.insert(
						details,
						string.format("│ Tier:      %s (%d)", tier_names[config.tier] or "unknown", config.tier)
					)
				end
				if config.requires then
					table.insert(details, string.format("│ Requires:  %s", table.concat(config.requires, ", ")))
				end
				table.insert(details, "│")
				table.insert(details, "│ Installed:  ✓")
				table.insert(details, "└─")

				return table.concat(details, "\n")
			end

			local picker = pickers.new({}, {
				prompt_title = "Installed Treesitter Parsers",
				finder = finders.new_table({
					results = installed,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry,
							ordinal = entry,
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						width = 0.8,
						height = 0.7,
						preview_width = 0.5,
					},
				},
				previewer = require("telescope.previewers").new_buffer_previewer({
					define_preview = function(self, entry)
						vim.api.nvim_buf_set_lines(
							self.state.bufnr,
							0,
							-1,
							false,
							vim.split(format_parser_details(entry.value), "\n")
						)
						vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "text")
					end,
				}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local entry = action_state.get_selected_entry()
						local details = format_parser_details(entry.value)

						local bufnr = vim.api.nvim_create_buf(false, true)
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(details, "\n"))
						vim.api.nvim_buf_set_option(bufnr, "filetype", "text")

						local width, height = 60, 12
						local row = math.floor((vim.o.lines - height) / 2)
						local col = math.floor((vim.o.columns - width) / 2)

						local winid = vim.api.nvim_open_win(bufnr, true, {
							relative = "editor",
							row = row,
							col = col,
							width = width,
							height = height,
							style = "minimal",
							border = "rounded",
							title = "Parser Details: " .. entry.value,
							title_pos = "center",
						})

						local function close_popup()
							if vim.api.nvim_win_is_valid(winid) then
								vim.api.nvim_win_close(winid, true)
							end
							if vim.api.nvim_buf_is_valid(bufnr) then
								vim.api.nvim_buf_delete(bufnr, { force = true })
							end
						end

						vim.keymap.set("n", "q", close_popup, { buffer = bufnr, silent = true })
						vim.keymap.set("n", "<Esc>", close_popup, { buffer = bufnr, silent = true })
						vim.keymap.set("n", "<CR>", close_popup, { buffer = bufnr, silent = true })
					end)
					map("i", "<C-j>", actions.move_selection_next)
					map("i", "<C-k>", actions.move_selection_previous)
					return true
				end,
			})
			picker:find()
		end, { desc = "List installed Treesitter parsers with details" })
	end,

	-----[[ Config ]]-----
	config = function()
		local config = require("nvim-treesitter")
		config.setup({})
	end,
}
