-- Debugging config
-- Have to install and config a debug adapter per language (see :help dap.txt or repo)
-- Each language's debug adapter has it's own setup config
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

			----------[[Dap Adapters Setup]]----------
			-- Codelldb (C/C++/Rust)
			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

				-- On windows you may have to uncomment this:
				-- detached = false,
			}

			-- Gdb (C/C++/Rust)
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

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

			-- C/C++ Using gdb
			-- dap.configurations.c = {
			-- 	{
			-- 		name = "Launch",
			-- 		type = "gdb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		args = {}, -- provide arguments if needed
			-- 		cwd = "${workspaceFolder}",
			-- 		stopAtBeginningOfMainSubprogram = false,
			-- 	},
			-- 	{
			-- 		name = "Select and attach to process",
			-- 		type = "gdb",
			-- 		request = "attach",
			-- 		program = function()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		pid = function()
			-- 			local name = vim.fn.input("Executable name (filter): ")
			-- 			return require("dap.utils").pick_process({ filter = name })
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 	},
			-- 	{
			-- 		name = "Attach to gdbserver :1234",
			-- 		type = "gdb",
			-- 		request = "attach",
			-- 		target = "localhost:1234",
			-- 		program = function()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 	},
			-- }
			-- dap.configurations.cpp = dap.configurations.c

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
