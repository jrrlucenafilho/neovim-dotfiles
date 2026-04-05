----- [[ Vim Options ]] -----
local opt = vim.opt
local g = vim.g
local diag = vim.diagnostic

-- Cursor handling and navigation
opt.number = true -- Show line numbers
opt.relativenumber = true -- Rlative number lines
opt.cursorline = true -- Highlight current line
opt.wrap = true -- Disable wrapping
opt.scrolloff = 10 -- Keep 10 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 collumns left/right cursor
opt.whichwrap = "b,s,h,l,<,>,[,]" -- Allow wrapping for these characters

-- Indentation
opt.expandtab = true --  Use spaces over tabs
opt.tabstop = 2 -- Tab width
opt.softtabstop = 2 -- Soft tab stop
opt.shiftwidth = 2 -- Indent width
opt.smartindent = true -- Auto smart-indenting
opt.autoindent = true -- Copy indenting from last line

-- Shell
opt.shell = "fish" -- Shell of choice

-- Search Settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Case sensitive if uppercase in search
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show matches as we're typing

-- Visual settings
opt.termguicolors = true -- Enable true color support
opt.guifont = { "JetBrainsMono Nerd Font", ":h11" } -- Font choide
opt.showmatch = true -- Highlight matching brackets
opt.winblend = 20 -- Floating windows transparency %
opt.pumblend = 20 -- Pop up menu tranparency %

----- [[ Globals ]] -----
-- Set leader characters
g.mapleader = " "
g.localleader = "\\"

-- Diagnostics appearing as text on file
diag.config({ virtual_text = false })

-- Set nvim virtual environment
g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")

-- Get environment variables (for neovide)
if g.neovide then
	-- Run Fish as a login shell and grab the full environment list
	local env_output = vim.fn.system("fish -lc 'env'")

	if vim.v.shell_error == 0 then
		for line in vim.gsplit(env_output, "\n") do
			-- Look for the KEY=VALUE pattern
			local key, val = line:match("^([^=]+)=(.*)$")

			-- Only set it if we found a pair and it's not a 'noisy' variable
			if key and val and key ~= "_" and key ~= "PWD" then
				vim.env[key] = val
			end
		end
	end
end
