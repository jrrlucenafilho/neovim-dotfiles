-- Zoxide for nvim
return {
	"alfaix/nvim-zoxide",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		-- will define Z[!], Zt[!], Zw[!] for :cd, :tcd, :lcd respectively
		-- set to false if you want to define different ones
		define_commands = true,
		-- path to zoxide executable; by default must be in $PATH
		path = "/usr/bin/zoxide",
	},
	config = function()
    require("zoxide").setup({})

    -- Keybind for quick navigation
		vim.keymap.set("n", "<leader>z", function()
			local query = vim.fn.input("Zoxide: ")
			if query and #query > 0 then
				vim.cmd("Z " .. query)
			end
		end, { desc = "Navigate using Zoxide" })
	end,
}
