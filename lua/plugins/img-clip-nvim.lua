-- to copy/paste imgs to codecompanion's chat buffer
-- Using :PasteImage
return {
	"HakonHarnes/img-clip.nvim",
	opts = {
		filetypes = {
			codecompanion = {
				prompt_for_file_name = false,
				template = "[Image]($FILE_PATH)",
				use_absolute_path = true,
			},
		},
	},
}
