-- Select venvs from inside neovim
return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
	},
	ft = "python", -- Load when opening Python files
	keys = {
		{
			"<leader>vv",
			"<cmd>VenvSelect<cr>",
			desc = "Select a virtual environment",
		}, -- Open picker on keymap
		{
			"<leader>vq",
			function()
				require("venv-selector").deactivate()
        print("Virtual environment deactivated")
			end,
			desc =  "Deactivate virtual environment",
		},
	},
	opts = { -- this can be an empty lua table - just showing below for clarity.
		search = {}, -- if you add your own searches, they go here.
		options = {}, -- if you add plugin options, they go here.
	},
}
