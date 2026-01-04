--copilot lsp
-- For code suggestions, THIS is whatt powers NES suggestions
return {
	"copilotlsp-nvim/copilot-lsp",
	init = function()
		vim.g.copilot_nes_debounce = 500
		vim.lsp.enable("copilot_ls")
		vim.keymap.set("n", "<tab>", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local state = vim.b[bufnr].nes_state
			if state then
				-- Try to jump to the start of the suggestion edit.
				-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
				local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
					or (
						require("copilot-lsp.nes").apply_pending_nes()
						and require("copilot-lsp.nes").walk_cursor_end_edit()
					)
				return nil
			else
				-- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
				return "<C-i>"
			end
		end, { desc = "Accept Copilot NES suggestion", expr = true })
	end,

	config = function()
		-- NES (Next edit suggestion smart clearing)
		require("copilot-lsp").setup({
			nes = {
				move_count_threshold = 2, -- Clear after 3 cursor movements
			},
		})

		-- Keybindings
		-- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
		vim.keymap.set("n", "<esc>", function()
		if not require("copilot-lsp.nes").clear() then
		-- fallback to other functionality (clear search highlight)
		vim.cmd("nohlsearch")
		end
		end, { desc = "Clear Copilot suggestion or fallback " })

		-- -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
		--   -- Allows clearing in insert mode as well
		--   vim.keymap.set({ "n", "i" }, "<Esc>", function()
		-- 	local nes = require("copilot-lsp.nes")
		--
		-- 	-- If a NES suggestion was cleared
		-- 	if nes.clear() then
		-- 		-- In insert mode, consume Esc and stay in insert
		-- 		if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
		-- 			return ""
		-- 		end
		-- 		-- In normal mode, just return
		-- 		return
		-- 	end
		--
		-- 	-- Fallback behavior
		-- 	if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
		-- 		return "<Esc>" -- normal Esc behavior
		-- 	else
		-- 		vim.cmd("nohlsearch")
		-- 	end
		-- end, {
		-- 	expr = true,
		-- 	desc = "Clear Copilot NES or fallback Esc behavior",
		-- })
	end,
}
