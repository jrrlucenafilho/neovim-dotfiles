--Lazy setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- local opts = {}

-- Vim config options
require("config.vim-options")

-- Kitty options
require("config.kitty-options")

-- Miscellaneous keymaps
require("config.keymaps")

-- Molten utils for jupyter notebook handling
require("utils.init-molten-buffer")
require("utils.new-notebook")

-- Load logger helper function for copilot.lua
require("utils.logger").setup()

-- Lazy config
require("lazy").setup("plugins")

-- Highlight matching parenthesis
vim.api.nvim_command("highlight MatchParen guibg=#45474a guifg=#b9babb")
