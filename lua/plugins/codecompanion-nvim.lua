-- Local and cloud LLM models
return {
	"olimorris/codecompanion.nvim",
	version = "^18.0.0", -- Tagging because plugin can have breaking changes
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim",
	},
	config = function()
		require("codecompanion").setup({
			opts = {
				log_level = "ERROR", -- or "TRACE"
			},

			display = {
				chat = {
					window = {
						position = "right",
						width = 0.3,
					},
					icons = {
						buffer_sync_all = "󰪴 ",
						buffer_sync_diff = " ",
						chat_context = " ",
						chat_fold = " ",
						tool_pending = "  ",
						tool_in_progress = "  ",
						tool_failure = "  ",
						tool_success = "  ",
					},
					fold_context = true,
				},
			},

			----------[[ General Adapters ]]----------
			adapters = {
				---[[ Acp Protocol ]]---
				acp = {
					opts = {
						show_presets = false,
					},

					-- [[ Cursor CLI ]] -- TODO: Make work
					cursor_cli_adapter = function()
						return require("codecompanion.adapters").extend("cursor_cli", {
							name = "cursor_cli",
							commands = {
								default = "cursor-agent",
							},
						})
					end,
				},
				----[[ Http Protocol ]]----
				http = {
					opts = {
						show_presets = false,
					},

					-----[[ Github Copilot ]]-----
					-- copilot = {
					-- 	name = "copilot",
					-- 	model = "gpt-4.1", -- Specify model if wanted (check available ones)
					-- },
					--
					-----[[ Gemini ]]-----
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = "gemini-2.5-flash",
									-- default = "gemini-2.5-flash-lite", -- choose one
								},
							},
							env = {
								api_key = os.getenv("GEMINI_API_KEY"),
							},
						})
					end,

					----[[ Ollama models ]]----
					---[[ Local Models ]]---
					--[[ Ollama qwen2.5-coder:7b-base-q5_K_M ]]
					ollama_qwen2_5_coder_7b_base_q5_K_M = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
							},
							parameters = {
								sync = true,
								model = "qwen2.5-coder:7b-base-q5_K_M",
							},
						})
					end,

					--[[ Ollama qwen2.5-coder:7b-instruct-q5_K_M]]
					ollama_qwen2_5_coder_7b_instruct_q5_K_M = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
							},
							parameters = {
								sync = true,
								model = "qwen2.5-coder:7b-instruct-q5_K_M",
							},
						})
					end,

					--[[ Ollama qwen3.5:9b-q4_K_M   ]]
					ollama_qwen3_5_9b_q4_K_M = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
							},
							parameters = {
								sync = true,
								model = "qwen3.5:9b-q4_K_M",
							},
						})
					end,

					--[[ Ollama qwen3.5:4b-q8_0 ]]
					ollama_qwen3_5_4b_q8_0 = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
							},
							parameters = {
								sync = true,
								model = "qwen3.5:4b-q8_0",
							},
						})
					end,

					---[[ Ollama Cloud Models ]]---
					--[[ Ollama qwen3-coder:480b-cloud ]]
					ollama_qwen3_coder_480b_cloud = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = os.getenv("OLLAMA_API_KEY"),
							},
							-- headers = {
							-- ["Content-Type"] = "application/json",
							-- ["Authorization"] = "Bearer ${api_key}",
							-- },
							parameters = {
								sync = true,
								model = "qwen3-coder:480b-cloud",
							},
						})
					end,

					--[[ Ollama devstral-2:123b-cloud ]]
					ollama_devstral_2_123b_cloud = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = os.getenv("OLLAMA_API_KEY"),
							},
							-- headers = {
							-- ["Content-Type"] = "application/json",
							-- ["Authorization"] = "Bearer ${api_key}",
							-- },
							parameters = {
								sync = true,
								model = "devstral-2:123b-cloud",
							},
						})
					end,

					--[[ Ollama devstral-small-2:24b-cloud ]]
					ollama_devstral_small_2_24b_cloud = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = os.getenv("OLLAMA_API_KEY"),
							},
							-- headers = {
							-- ["Content-Type"] = "application/json",
							-- ["Authorization"] = "Bearer ${api_key}",
							-- },
							parameters = {
								sync = true,
								model = "devstral-small-2:24b-cloud",
							},
						})
					end,

					--[[ Ollama gemini-3-pro-preview:latest ]]
					ollama_gemini_3_pro_preview_cloud = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = os.getenv("OLLAMA_API_KEY"),
							},
							-- headers = {
							-- ["Content-Type"] = "application/json",
							-- ["Authorization"] = "Bearer ${api_key}",
							-- },
							parameters = {
								sync = true,
								model = "gemini-3-pro-preview:latest",
							},
						})
					end,

					--[[ Ollama gemini-3-flash-preview:cloud ]]
					ollama_gemini_3_flash_preview_cloud = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = os.getenv("OLLAMA_API_KEY"),
							},
							-- headers = {
							-- ["Content-Type"] = "application/json",
							-- ["Authorization"] = "Bearer ${api_key}",
							-- },
							parameters = {
								sync = true,
								model = "gemini-3-flash-preview:cloud",
							},
						})
					end,
				},
			},

			--[[ Interactions
      - Interaction types:
        - Chat - A chat buffer where you can converse with an LLM (:CodeCompanionChat) (ACP only works here)
        - Inline - An inline assistant that can write code directly into a buffer (:CodeCompanion)
        - Cmd - Create Neovim commands in the command-line (:CodeCompanionCmd)
        - Background - Runs tasks in the background such as compacting chat messages or generating titles for chats
      ]]
			----------[[ Default Adapters For Each Interaction ]]----------
			interactions = {
				chat = {
					opts = {
						completion_provider = "cmp",
					},
					adapter = {
						-- protocol = "acp", name = "cursor_cli"
						name = "copilot",
						--[[ Model names for copilot provider ]]
						-- Check rates here: https://docs.github.com/en/copilot/reference/ai-models/supported-models
						model = "gpt-4.1",
						-- model = "claude-sonnet-4.5" (Gone)
						-- model = "gemini-3.5-pro-preview"
						-- model = "gpt-5.1-codex"
						-- model = "gpt-5.2-codex"
						-- model = "gemini-3-pro-preview"
						-- model = "gpt-5.1-codex-mini"
						-- model = "gemini-3-flash-preview"
						-- model = "gpt-5.4"
						-- model = "gpt-5.3-codex-mx"
						-- model = "gemini-2.5-pro"
						-- model = "gpt-5-mini"
						-- model = "claude-opus-4.5" (Gone)
						-- model = "gpt-5.2"
						-- model = "oswe-vscode-prime"
						-- model = "gpt-4o"
						-- model = "gpt-5.3-codex"
						-- model = "claude-sonnet-4" (Gone)
						-- model = "gpt-5.1"
						-- model = "claude-opus-4.6" (Gone)
						-- model = "grok-code-fast-1"
						-- model = "claude-haiku-4.5"
						-- model = "claude-sonnet-4.6" (Gone)
					},
				},

				inline = {
					adapter = "copilot",
				},

				cmd = {
					adapter = "copilot",
				},

				background = {
					adapter = "copilot",
				},
			},

			extensions = {
				history = {
					enabled = true,
					opts = {
						-- Keymap to open history from chat buffer (default: gh)
						keymap = "gh",
						-- Keymap to save the current chat manually (when auto_save is disabled)
						save_chat_keymap = "sc",
						-- Save all chats by default (disable to save only manually using 'sc')
						auto_save = true,
						-- Number of days after which chats are automatically deleted (0 to disable)
						expiration_days = 0,
						-- Picker interface (auto resolved to a valid picker)
						picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
						---Optional filter function to control which chats are shown when browsing
						chat_filter = nil, -- function(chat_data) return boolean end
						-- Customize picker keymaps (optional)
						picker_keymaps = {
							rename = { n = "r", i = "<M-r>" },
							delete = { n = "d", i = "<M-d>" },
							duplicate = { n = "<C-y>", i = "<C-y>" },
						},
						---Automatically generate titles for new chats
						auto_generate_title = true,
						title_generation_opts = {
							---Adapter for generating titles (defaults to current chat adapter)
							adapter = nil, -- "copilot"
							---Model for generating titles (defaults to current chat model)
							model = nil, -- "gpt-4o"
							---Number of user prompts after which to refresh the title (0 to disable)
							refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
							---Maximum number of times to refresh the title (default: 3)
							max_refreshes = 3,
							format_title = function(original_title)
								-- this can be a custom function that applies some custom
								-- formatting to the title.
								return original_title
							end,
						},
						---On exiting and entering neovim, loads the last chat on opening chat
						continue_last_chat = false,
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = false,
						---Directory path to save the chats
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						---Enable detailed logging for history extension
						enable_logging = false,

						-- Summary system
						summary = {
							-- Keymap to generate summary for current chat (default: "gcs")
							create_summary_keymap = "gcs",
							-- Keymap to browse summaries (default: "gbs")
							browse_summaries_keymap = "gbs",

							generation_opts = {
								adapter = nil, -- defaults to current chat adapter
								model = nil, -- defaults to current chat model
								context_size = 90000, -- max tokens that the model supports
								include_references = true, -- include slash command content
								include_tool_outputs = true, -- include tool execution results
								system_prompt = nil, -- custom system prompt (string or function)
								format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
							},
						},

						-- Memory system (requires VectorCode CLI)
						memory = {
							-- Automatically index summaries when they are generated
							auto_create_memories_on_summary_generation = true,
							-- Path to the VectorCode executable
							vectorcode_exe = "vectorcode",
							-- Tool configuration
							tool_opts = {
								-- Default number of memories to retrieve
								default_num = 10,
							},
							-- Enable notifications for indexing progress
							notify = true,
							-- Index all existing memories on startup
							-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
							index_on_startup = false,
						},
					},
				},
			},
		})

		-----------[[ Autocmds ]]---------
		-- Disable line count for chat buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.opt_local.number = false
			end,
		})

		-- Auto open codecompanion's commit writer when neogit's commit buffer opens
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitcommit",
			callback = function()
				vim.api.nvim_command("CodeCompanion /commit")
			end,
		})

		-- Keep chat buffer as fixed size
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.opt_local.winfixwidth = true
			end,
		})

		-- Prevent other buffers from taking over the CodeCompanion chat window (aggressive)
		-- Mark chat window and store its buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.w.codecompanion_protect = true
				vim.w.codecompanion_bufnr = vim.api.nvim_get_current_buf()
			end,
		})

		-- Corrected chat buffer protection: only restore in the chat window itself
		vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
			callback = function()
				local win = vim.api.nvim_get_current_win()
				if vim.w.codecompanion_protect and vim.w.codecompanion_bufnr then
					local cur_buf = vim.api.nvim_win_get_buf(win)
					local cur_ft = vim.api.nvim_buf_get_option(cur_buf, "filetype")
					-- Only restore if the chat window is showing a non-chat buffer
					if cur_ft ~= "codecompanion" and vim.api.nvim_buf_is_valid(vim.w.codecompanion_bufnr) then
						vim.schedule(function()
							-- Restore the chat buffer in the original window
							if
								vim.api.nvim_win_is_valid(win)
								and vim.api.nvim_buf_is_valid(vim.w.codecompanion_bufnr)
							then
								vim.api.nvim_win_set_buf(win, vim.w.codecompanion_bufnr)
							end
							-- Mark the buffer to focus on next BufEnter
							vim.g.codecompanion_focus_buf = cur_buf
							-- Immediately try to focus the buffer or fallback to unnamed buffer
							local found = false
							for _, w in ipairs(vim.api.nvim_list_wins()) do
								local b = vim.api.nvim_win_get_buf(w)
								local name = vim.api.nvim_buf_get_name(b)
							end
							for _, w in ipairs(vim.api.nvim_list_wins()) do
								if vim.api.nvim_win_get_buf(w) == cur_buf then
									found = true
									vim.api.nvim_set_current_win(w)
									break
								end
							end
							if not found then
								local unnamed_win = nil
								local file_win = nil
								for _, w in ipairs(vim.api.nvim_list_wins()) do
									local b = vim.api.nvim_win_get_buf(w)
									local name = vim.api.nvim_buf_get_name(b)
									if name == "" and not unnamed_win then
										unnamed_win = w
									elseif name ~= "" and not file_win then
										file_win = w
									end
								end
								if unnamed_win then
									vim.api.nvim_set_current_win(unnamed_win)
									-- If the target buffer is loaded, display it in this window
									if vim.api.nvim_buf_is_loaded(cur_buf) then
										-- Save the unnamed buffer number before switching
										local unnamed_buf = vim.api.nvim_win_get_buf(unnamed_win)
										vim.api.nvim_win_set_buf(unnamed_win, cur_buf)
										-- Now close the old unnamed buffer
										if unnamed_buf ~= cur_buf and vim.api.nvim_buf_is_valid(unnamed_buf) then
											vim.api.nvim_buf_delete(unnamed_buf, { force = true })
										end
									else
									end
								else
								end
							end
						end)
					end
				end
			end,
		})

		----------[[ Keymaps ]]----------
		vim.keymap.set(
			{ "n", "v" },
			"<localleader>a",
			"<cmd>CodeCompanionActions<cr>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<C-a>",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ desc = "Toggle CodeCompanion chat", noremap = true, silent = true }
		)
		vim.keymap.set(
			"v",
			"ga",
			"<cmd>CodeCompanionChat Add<cr>",
			{ desc = "Add selection to CodeCompanion chat", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<localleader>c",
			"<cmd>CodeCompanion /commit<cr>",
			{ desc = "Open CodeCompanion commit chat", noremap = true, silent = true }
		)

		-- Toggle CodeCompanion chat window width between normal (default config) and expanded width
		local function toggle_codecompanion_width()
			local normal_width = math.floor(vim.o.columns * 0.3) -- match config default
			local expanded_width = math.floor(vim.o.columns * 0.5)
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_buf_get_option(buf, "filetype")
				if ft == "codecompanion" then
					local cur_width = vim.api.nvim_win_get_width(win)
					local new_width = normal_width
					if math.abs(cur_width - normal_width) < 2 then
						new_width = expanded_width
					end
					vim.api.nvim_win_set_width(win, new_width)
					break
				end
			end
		end
		vim.keymap.set(
			{ "n", "t" },
			"<leader>ae",
			toggle_codecompanion_width,
			{ desc = "Toggle CodeCompanion chat width" }
		)

		-- [[ Miscellaneous Configs ]]
		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
