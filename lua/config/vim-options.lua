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

-- Get environment variables (for neovide)
if vim.g.neovide then
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
