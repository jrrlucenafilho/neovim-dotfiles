-- Disables some features when editing big files for performance
return {
	"pteroctopus/faster.nvim",

	config = function()
		require("faster").setup({
			-- Behaviour table contains configuration for behaviours faster.nvim uses
			behaviours = {
				-- Bigfile configuration controls disabling and enabling of features when
				-- big file is opened
				bigfile = {
					-- Behaviour can be turned on or off. To turn on set to true, otherwise
					-- set to false
					on = true,
					-- Table which contains names of features that will be disabled when
					-- bigfile is opened. Feature names can be seen in features table below.
					-- features_disabled can also be set to "all" and then all features that
					-- are on (on=true) are going to be disabled for this behaviour
					features_disabled = {
						"illuminate",
						"matchparen",
						"lsp",
						"treesitter",
						"indent_blankline",
						"vimopts",
						"syntax",
						"filetype",
					},
					-- Files larger than `filesize` are considered big files. Value is in MB.
					filesize = 2000,
					-- Autocmd pattern that controls on which files behaviour will be applied.
					-- `*` means any file.
					pattern = "*",
					-- Optional extra patterns and sizes for which bigfile behaviour will apply.
					-- Note! that when multiple patterns (including the main one) and filesizes
					-- are defined: bigfile behaviour will be applied for minimum filesize of
					-- those defined in all applicable patterns for that file.
					-- extra_pattern example in multi line comment is bellow:
					--[[
      extra_patterns = {
        -- If this is used than bigfile behaviour for *.md files will be
        -- triggered for filesize of 1.1MiB
        { filesize = 1.1, pattern = "*.md" },
        -- If this is used than bigfile behaviour for *.log file will be
        -- triggered for the value in `behaviours.bigfile.filesize`
        { pattern  = "*.log" },
        -- Next line is invalid without the pattern and will be ignored
        { filesize = 3 },
      },
      ]]
					-- By default `extra_patterns` is an empty table: {}.
					extra_patterns = {},
					-- When true, fires a one-shot `vim.notify` (INFO level, title
					-- "faster.nvim") each time bigfile mode activates for a buffer,
					-- e.g. "faster.nvim active for big_log.txt (5.3 MiB)". Works with
					-- any notify plugin (nvim-notify, noice, mini.notify, snacks.notifier)
					-- and falls back to the built-in command-line message if no plugin
					-- replaces vim.notify. On launch-with-file-arg (e.g. `nvim big.log`),
					-- the message may still land in the cmdline if your notify plugin
					-- lazy-loads after BufReadPost. Set to false to silence.
					notify = true,
				},
				-- Long-line behaviour catches files that aren't large in total bytes but
				-- have very long lines (minified JS/JSON/CSS, single-line log files).
				-- These choke treesitter and syntax highlighting harder than typical big
				-- files, but bigfile detection misses them because their byte count is
				-- low. Detection uses filesize / line_count as a cheap heuristic.
				longline = {
					on = true,
					-- Same shape as bigfile.features_disabled. "all" is also accepted.
					features_disabled = {
						"illuminate",
						"matchparen",
						"lsp",
						"treesitter",
						"indent_blankline",
						"vimopts",
						"syntax",
						"filetype",
					},
					-- File must be at least this size (MiB) to be considered. Default
					-- 10 KiB skips tiny files even if their line count is artificially low.
					filesize = 0.01,
					-- Trigger when filesize_bytes / line_count > avg_bytes_per_line.
					avg_bytes_per_line = 250,
					pattern = "*",
					-- Same extra_patterns shape as bigfile; both filesize and
					-- avg_bytes_per_line are overridable per pattern.
					--[[
      extra_patterns = {
        { pattern = "*.js",  avg_bytes_per_line = 200 },
        { pattern = "*.css", filesize = 0.05 },
      },
      ]]
					extra_patterns = {},
					-- Same vim.notify behaviour as bigfile (see notify above).
					notify = true,
				},
				-- Fast macro configuration controls disabling and enabling features when
				-- macro is executed
				fastmacro = {
					-- Behaviour can be turned on or off. To turn on set to true, otherwise
					-- set to false
					on = true,
					-- Table which contains names of features that will be disabled when
					-- macro is executed. Feature names can be seen in features table below.
					-- features_disabled can also be set to "all" and then all features that
					-- are on (on=true) are going to be disabled for this behaviour.
					-- Specificaly:
					-- * lualine plugin is disabled when macros are executed because
					-- if a recursive macro opens a buffer on every iteration this error will
					-- happen after 300-400 hundred iterations:
					-- `E5108: Error executing lua Vim:E903: Process failed to start: too many open files: "/usr/bin/git"`
					-- * mini.clue plugin is disabled when macros are executed because it breaks execution of some macros
					features_disabled = { "lualine", "mini_clue" },
				},
			},
			-- Feature table contains configuration for features faster.nvim will disable
			-- and enable according to rules defined in behaviours.
			-- Defined feature will be used by faster.nvim only if it is on (`on=true`).
			-- Defer will be used if some features need to be disabled after others.
			-- defer=false features will be disabled first and defer=true features last.
			features = {
				-- Neovim filetype plugin
				-- https://neovim.io/doc/user/filetype.html
				filetype = {
					on = true,
					defer = true,
				},
				-- Illuminate plugin
				-- https://github.com/RRethy/vim-illuminate
				illuminate = {
					on = true,
					defer = false,
				},
				-- Indent Blankline
				-- https://github.com/lukas-reineke/indent-blankline.nvim
				indent_blankline = {
					on = true,
					defer = false,
				},
				-- Neovim LSP
				-- https://neovim.io/doc/user/lsp.html
				lsp = {
					on = true,
					defer = false,
				},
				-- Lualine
				-- https://github.com/nvim-lualine/lualine.nvim
				lualine = {
					on = true,
					defer = false,
				},
				-- Neovim Pi_paren plugin
				-- https://neovim.io/doc/user/pi_paren.html
				matchparen = {
					on = true,
					defer = false,
				},
				-- Neovim syntax
				-- https://neovim.io/doc/user/syntax.html
				syntax = {
					on = true,
					defer = true,
				},
				-- Neovim treesitter
				-- https://neovim.io/doc/user/treesitter.html
				treesitter = {
					on = true,
					defer = false,
				},
				-- Neovim options that affect speed when big file is opened:
				-- swapfile, foldmethod, undolevels, undoreload, list
				vimopts = {
					on = true,
					defer = false,
				},
				-- Mini.clue
				-- https://github.com/nvim-mini/mini.clue
				mini_clue = {
					on = true,
					defer = false,
				},
			},
		})
	end,
}
