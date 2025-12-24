-- Debugging config
-- Have to install and config a debug adapter per language (see :help dap.txt or repo)
-- Each language's debug adapter has it's own setup config
-- Config for each can be found here: https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},

		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			----------[[Debug Adapters Setup]]----------
			-- Codelldb (C/C++/Rust)
			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

				-- On windows you may have to uncomment this:
				-- detached = false,
			}

			-- vscode-js-debug (JavaScript/TypeScript)
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					-- Make sure to update this path to point to your installation
					args = { "/usr/lib/js-debug/dapDebugServer.js", "${port}" },
				},
			}

			-- debugpy (Python)
			dap.adapters.python = function(cb, config)
				if config.request == "attach" then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or "127.0.0.1"
					cb({
						type = "server",
						port = assert(port, "`connect.port` is required for a python `attach` configuration"),
						host = host,
						options = {
							source_filetype = "python",
						},
					})
				else
					cb({
						type = "executable",
						command = "/home/jrrlu/.virtualenvs/debugpy/bin/python",
						args = { "-m", "debugpy.adapter" },
						options = {
							source_filetype = "python",
						},
					})
				end
			end

			----------[[ Dap Configurations Setup ]]----------
			-- C/C++ using codelldb
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp

			-- JavaScript/TypeScript using vscode-js-debug
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMap = true, -- For TypeScript
				},
			}
			dap.configurations.typescript = dap.configurations.javascript

			-- Python with debugpy
			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch file",

					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
					-- for supported options

					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
						-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
						local cwd = vim.fn.getcwd()
						if os.getenv("VIRTUAL_ENV") then
							return os.getenv("VIRTUAL_ENV") .. "/bin/python"
						elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						else
							return "/usr/bin/python"
						end
					end,
				},
			}

			----------[[Debugging keybinds]]----------
			vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>", { desc = "Continue debugging" })
			vim.keymap.set("n", "<Leader>dq", ":DapTerminate<CR>", { desc = "Terminate debugging session" })
			vim.keymap.set("n", "<Leader>dov", ":DapStepOver<CR>", { desc = "Step over (debugging)" })
			vim.keymap.set("n", "<Leader>di", ":DapStepInto<CR>", { desc = "Step into (debugging)" })
			vim.keymap.set("n", "<Leader>dou", ":DapStepOut<CR>", { desc = "Step out (debugging)" })
			vim.keymap.set("n", "<Leader>dr", ":DapRestartFrame<CR>", { desc = "Restart frame (debugging)" })
		end,
	},
	{ -- Go
		"leoluz/nvim-dap-go",

		config = function()
			require("dap-go").setup()
		end,
	},
}
