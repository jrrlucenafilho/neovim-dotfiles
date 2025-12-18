-- Multi-cursor features
return {
	"mg979/vim-visual-multi",

	init = function()
		-- vim.g.VM_leader = {'\\\\'} -- It's the default
		vim.g.VM_maps = {
			["Find Under"] = "gm",
      ["Visual Find Under"] = "gm",
			["Find Subword Under"] = "gm",
			["Select All"] = "\\A",
			["Start Regex Search"] = "\\/",
			["Add Cursor Down"] = "<C-Down>",
			["Add Cursor Up"] = "<C-Up>",
			["Add Cursor At Pos"] = "\\\\\\",
		}
	end,
}
