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
			callback = function()
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				-- Folding behavior (Disabled it in options)
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
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
	end,

	-----[[ Config ]]-----
	config = function()
		local config = require("nvim-treesitter")
		config.setup({})
	end,
}
