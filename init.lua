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

-- Prepend treesitter's parsers folder to runtime path
vim.opt.runtimepath:prepend("/home/jrrlu/.local/share/nvim/site")

-- local opts = {}

-- Vim config options
require("config.options")

-- Miscellaneous keymaps
require("config.keymaps")

-- Miscellaneous autocmds
require("config.autocmds")

-- Molten utils for jupyter notebook handling
require("utils.init-molten-buffer")
require("utils.new-notebook")

-- Load logger helper function for copilot.lua
require("utils.logger").setup()

-- Lazy config
require("lazy").setup("plugins")

-- Set Window Separator
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#464e6a" })
