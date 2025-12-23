-- Local and cloud LLM models
return {
	"olimorris/codecompanion.nvim",
	version = "^18.0.0", -- Tagging because plugin can have breaking changes
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			opts = {
				log_level = "DEBUG", -- or "TRACE"
			},

			display = {
				chat = {
					window = {
						position = "right",
						width = 0.3,
					},
					icons = {
						buffer_sync_all = "󰪴 ",
						buffer_sync_diff = " ",
						chat_context = " ",
						chat_fold = " ",
						tool_pending = "  ",
						tool_in_progress = "  ",
						tool_failure = "  ",
						tool_success = "  ",
					},
					fold_context = true,
				},
			},

			--[[
    Each 'model config' is an 'interaction'
    - Interaction types:
      - Chat - A chat buffer where you can converse with an LLM (:CodeCompanionChat) (ACP only works here)
      - Inline - An inline assistant that can write code directly into a buffer (:CodeCompanion)
      - Cmd - Create Neovim commands in the command-line (:CodeCompanionCmd)
      - Background - Runs tasks in the background such as compacting chat messages or generating titles for chats
    ]]
			interactions = {
				chat = {
					opts = {
						completion_provider = "cmp",
					},
					adapter = {
						name = "copilot",
						model = "gpt-4.1",
					},
				},

				inline = {
					adapter = {
						name = "copilot",
						model = "gpt-4.1",
					},
				},

				cmd = {
					adapter = {
						name = "copilot",
						model = "gpt-4.1",
					},
				},

				background = {
					adapter = {
						name = "copilot",
						model = "gpt-4.1",
					},
				},
			},
		})

		-- Keybindings
		vim.keymap.set({ "n", "v" }, "<localleader>a", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
		vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
