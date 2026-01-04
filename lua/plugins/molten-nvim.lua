-- Jupyter notebook support through markdown
-- Remember to always install ipykernel in the kernel virtualenv
return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		dependencies = { "3rd/image.nvim" },
		build = ":updateremoteplugins",
		ft = { "quarto", "markdown" },
		init = function()
			-- these are examples, not defaults. please see the readme
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
		end,

		config = function()
			-- Standart Configs
			-- I find auto open annoying, keep in mind setting this option will require setting
			-- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
			vim.g.molten_auto_open_output = false

			-- this guide will be using image.nvim
			-- Don't forget to setup and install the plugin if you want to view image outputs
			vim.g.molten_image_provider = "image.nvim"

			-- optional, I like wrapping. works for virt text and the output window
			vim.g.molten_wrap_output = true

			-- Output as virtual text. Allows outputs to always be shown, works with images, but can
			-- be buggy with longer images
			vim.g.molten_virt_text_output = true

			-- this will make it so the output shows up below the \`\`\` cell delimiter
			vim.g.molten_virt_lines_off_by_1 = true

			-- Keybindings
			-- Make new notebook (already formatted)
			-- using the util function
			vim.keymap.set("n", "<localleader>nb", ":NewNotebook ", { desc = "Create new jupyter notebook" })

			-- Auto-activate Molten in the corresponding virtual environment
			vim.keymap.set("n", "<localleader>mi", function()
				local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
				if venv ~= nil then
					-- in the form of /home/benlubas/.virtualenvs/VENV_NAME
					venv = string.match(venv, "/.+/(.+)")
					vim.cmd(("MoltenInit %s"):format(venv))
				else
					vim.cmd("MoltenInit python3")
				end
			end, { desc = "Initialize Molten for python3", silent = true })

			-- Evaluate Operator
			vim.keymap.set(
				"n",
				"<localleader>eop",
				":MoltenEvaluateOperator<CR>",
				{ desc = "Evaluate operator", silent = true }
			)

			-- Open output window
			vim.keymap.set(
				"n",
				"<localleader>o",
				":noautocmd MoltenEnterOutput<CR>",
				{ desc = "Open output window", silent = true }
			)

			-- Re-evaluate cell
			vim.keymap.set(
				"n",
				"<localleader>rvc",
				":MoltenReevaluateCell<CR>",
				{ desc = "Re-eval cell", silent = true }
			)

			-- Execute visual selection
			vim.keymap.set(
				"v",
				"<localleader>vs",
				":<C-u>MoltenEvaluateVisual<CR>gv",
				{ desc = "Execute visual selection", silent = true }
			)

			-- Close output window
			vim.keymap.set(
				"n",
				"<localleader>O",
				":MoltenHideOutput<CR>",
				{ desc = "Close output window", silent = true }
			)

			-- Delete cell
			vim.keymap.set("n", "<localleader>dc", ":MoltenDelete<CR>", { desc = "Delete Molten cell", silent = true })

			-- Open output in browser (if you work with html outputs)
			vim.keymap.set(
				"n",
				"<localleader>b",
				":MoltenOpenInBrowser<CR>",
				{ desc = "Open output in browser", silent = true }
			)

			-- Quarto keybindings (runner)
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "Run cell", silent = true })
			vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "Run cell and above", silent = true })
			vim.keymap.set("n", "<localleader>rb", runner.run_below, { desc = "Run cell and below", silent = true })
			vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "Run all cells", silent = true })
			vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "Run line", silent = true })
			vim.keymap.set("v", "<localleader>rr", runner.run_range, { desc = "Run visual range", silent = true })
			vim.keymap.set("n", "<localleader>RA", function()
				runner.run_all(true)
			end, { desc = "Run all cells of all languages", silent = true })
		end,
	},
}
