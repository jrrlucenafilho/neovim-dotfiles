-- Responsible for LSP settings and
-- LSP-related keybinds
return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"clangd",
				"html",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Capabilities allows for LSPs to provide completions as well
			-- clangd
			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})
			vim.lsp.enable("clangd")

			-- ts_ls
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls")

			-- lua_ls
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				filetypes = { "lua" },
				-- cmd = { "/usr/bin/lua-language-server" }, -- Use pacman's bin package if mason's breaks
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					".git",
				},
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim", "CsvView.Options" },
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			-- html-lsp
			vim.lsp.config("html", {
				capabilities = capabilities,
			})
			vim.lsp.enable("html")

      -- basedpyright
      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
      })
      vim.lsp.enable("basedpyright")

			-- General Keybinds
			vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Hover over" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Check definition" })
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
		end,
	},
}
