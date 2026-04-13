-- Claude Code support
return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	keys = {
		-- { "<leader>a", nil, mode = {"n", "t"}, desc = "AI/Claude Code" },

		-- { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", mode = { "n", "t" }, desc = "Focus Claude" },
		{ "<leader>cct", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "Toggle Claude" },
		{ "<leader>ccr", "<cmd>ClaudeCode --resume<cr>", mode = { "n", "t" }, desc = "Resume Claude" },
		{ "<leader>ccC", "<cmd>ClaudeCode --continue<cr>", mode = { "n", "t" }, desc = "Continue Claude" },
		{ "<leader>ccm", "<cmd>ClaudeCodeSelectModel<cr>", mode = { "n", "t" }, desc = "Select Claude model" },
		{ "<leader>cca", "<cmd>ClaudeCodeAdd %<cr>", mode = { "n", "t" }, desc = "Add current buffer" },
		{ "<leader>ccs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>cct",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			mode = { "n", "t" },
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>ccda", "<cmd>ClaudeCodeDiffAccept<cr>", mode = { "n", "t" }, desc = "Accept diff" },
		{ "<leader>ccdd", "<cmd>ClaudeCodeDiffDeny<cr>", mode = { "n", "t" }, desc = "Deny diff" },
	},
}
