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
			-- clangd (C, C++)
			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})
			vim.lsp.enable("clangd")

			-- ts_ls (Javascript/Typescript)
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls")

			-- eslint-lsp (Javascript/Typescript)
			vim.lsp.config("eslint-lsp", {
				capabilities = capabilities,
			})
			vim.lsp.enable("eslint-lsp")

			-- lua_ls (Lua)
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				filetypes = { "lua" },
				root_markers = {
					"main.lua",
					"love.conf",
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					".git",
				},

				-- Just so it only loads love2d and 3rd-party libraries in project mode
				on_new_config = function(new_config, root_dir)
					-- Ensure tables exist
					new_config.settings = new_config.settings or {}
					new_config.settings.Lua = new_config.settings.Lua or {}
					new_config.settings.Lua.workspace = new_config.settings.Lua.workspace or {}

					if root_dir then
						-- Project mode → enable LÖVE + 3rd-party libs
						new_config.settings.Lua.workspace.checkThirdParty = true
						new_config.settings.Lua.workspace.library = {
							vim.fn.expand("$VIMRUNTIME/lua"),
							vim.fn.stdpath("data") .. "/lazy/love2d.nvim/library",
						}
					else
						-- Single-file mode → no 3rd-party probing
						new_config.settings.Lua.workspace.checkThirdParty = false
						new_config.settings.Lua.workspace.library = nil
					end
				end,

				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							special = {
								-- ["love.filesystem.load"] = "loadfile",
							},
						},

						diagnostics = {
							globals = { "vim", "love", "logger" },
						},

						workspace = {},
					},
				},
			})

			vim.lsp.enable("lua_ls")

			-- html-lsp (Html)
			vim.lsp.config("html", {
				capabilities = capabilities,
			})
			vim.lsp.enable("html")

			-- basedpyright (Python)
			vim.lsp.config("basedpyright", {
				capabilities = capabilities,
			})
			vim.lsp.enable("basedpyright")

			-- yamlls (yaml)
			vim.lsp.config("yamlls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("yamlls")

			-- tailwindcss (css)
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
			})
			vim.lsp.enable("tailwindcss")

			-- fish_lsp (fish)
			vim.lsp.config("fish_lsp", {
				capabilities = capabilities,
			})
			vim.lsp.enable("fish_lsp")

			-- General Keybinds
			vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Hover over" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Check definition" })
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
		end,
	},
}
