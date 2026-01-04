-- Well... completions
-- nvim_cmp opens up a windows
-- data within this window is driven by luasnip and friendly-snippets
-- when pressing enter, it's completed by cmp_luasnip
-- Meanwhile, cmp_nvim_lsp asks LSP for completion suggestions
-- (gotta add the capabilities in each LSP for this last one)
return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets", -- vscode snippets
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			-- Set up nvim-cmp.
			local cmp = require("cmp")

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- for LSP completions
					{ name = "luasnip" }, -- For luasnip users.
					per_filetype = {
						codecompanion = { "codecompanion" }, --codecompanion's chat buffer
					},
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
