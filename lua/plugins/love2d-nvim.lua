-- Love2D runner
return {
	"S1M0N38/love2d.nvim",
	-- event = "VeryLazy",
	-- ft= "lua",
	version = "2.*",
	event = "BufReadPost",
	opts = {},
	keys = {
		{ "<leader>v", ft = "lua", desc = "LÖVE" },
		{ "<leader>vr", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
		{ "<leader>vq", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
	},

	cond = function()
		local buf = vim.api.nvim_get_current_buf()
		local path = vim.api.nvim_buf_get_name(buf)
		if path == "" then
			return false
		end

		return vim.fs.root(path, { "main.lua", "love.conf" }) ~= nil
	end,
}
