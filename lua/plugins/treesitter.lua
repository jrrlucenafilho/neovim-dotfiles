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

		-- Keymap to list installed parsers in Telescope
		vim.keymap.set("n", "<leader>tp", function()
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values

			local parsers = require("nvim-treesitter.config").get_installed()

			local picker = pickers.new({}, {
				prompt_title = "Installed Treesitter Parsers",
				finder = finders.new_table({
					results = parsers,
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
						width = 0.3,
						height = 0.6,
					},
				},
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local entry = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						print("Selected parser: " .. entry.value)
					end)
					return true
				end,
			})
			picker:find()
		end, { desc = "List installed Treesitter parsers" })
	end,

	-----[[ Config ]]-----
	config = function()
		local config = require("nvim-treesitter")
		config.setup({})
	end,
}
