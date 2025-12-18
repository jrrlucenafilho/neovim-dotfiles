-- Standart vim configs
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")

-- Shell of choice
vim.opt.shell = "fish"

-- Font
vim.opt.guifont = { "JetBrainsMono Nerd Font", ":h11" }

-- Set leader characters
vim.g.mapleader = " "
vim.g.localleader = "\\"

-- Diagnostics appearing as text on file
vim.diagnostic.config({ virtual_text = false })

-- Set nvim virtual environment
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
