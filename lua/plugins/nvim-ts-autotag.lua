-- Auto-close tag support for many languages, such as html, typescript, tsx, etc.
return {
	"windwp/nvim-ts-autotag",
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				-- Defaults
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = false, -- Auto close on trailing </
			},
			-- Also override individual filetype configs, these take priority.
			-- Empty by default, useful if one of the "opts" global settings
			-- doesn't work well in a specific filetype
			-- Use only if needed
			per_filetype = {
				-- ["html"] = {
				-- enable_close = false,
			},
		})
	end,
}
