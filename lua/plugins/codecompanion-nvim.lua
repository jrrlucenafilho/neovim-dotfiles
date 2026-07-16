-- Local and cloud LLM models
return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0", -- Tagging because plugin can have breaking changes
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
						width = 0.23,
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

			prompt_library = {
				markdown = {
					dirs = {
						"~/.config/nvim/prompt-lib",
					},
				},
			},

			----------[[ General Adapters ]]----------
			adapters = {
				---[[ Acp Protocol ]]---
				acp = {
					opts = {
						show_presets = false,
					},

					----- [[ Cursor CLI ]] -----
					-- Models come from the agent via ACP (`session/update`); pick them with `ga` in chat.
					-- Only `defaults.model` is read for ACP (see codecompanion's 'gd' debug buffer when cursor_cli is sselected).
					-- The standart model here is empty, so Cursor itself decides it (desire behavior for now)
					-- And the UI models list comes from what models Cursor exposes through ACP
					cursor_cli = function()
						return require("codecompanion.adapters").extend("cursor_cli", {
							defaults = {
								session_config_options = {
									model = "Auto",
								},
							},
						})
					end,

					----- [[ Claude Code ]] -----
					--- Install claude-agent-acp from the aur
					--- Set ANTHROPIC_BASE_URL to the API's one
					--- Set ANTHROPIC_AUTH_TOKEN to the API key
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							defaults = {
								session_config_options = {
									model = "Haiku",
								},
							},
						})
					end,

					----- [[ OpenCode ]] -----
					opencode = function()
						return require("codecompanion.adapters").extend("opencode", {
							defaults = {
								session_config_options = {
									-- model = "OpenCode Zen/DeepSeek V4 Flash Free", --Testing official API
									model = "DeepSeek/DeepSeek V4 Flash",
									thought_level = "High",
								},
							},
						})
					end,
				},

				----[[ Http Protocol ]]----
				http = {
					opts = {
						show_presets = false,
					},

					-- ----- [[ Github Copilot ]]-----
					-- Model names for copilot provider:
					-- Check rates here: https://docs.github.com/en/copilot/reference/ai-models/supported-models
					-- model = "gpt-4.1",
					-- model = "claude-sonnet-4.5" (Non-Student)
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
					-- model = "claude-opus-4.5" (Non-Student)
					-- model = "gpt-5.2"
					-- model = "oswe-vscode-prime"
					-- model = "gpt-4o"
					-- model = "gpt-5.3-codex"
					-- model = "claude-sonnet-4" (Non-Student)
					-- model = "gpt-5.1"
					-- model = "claude-opus-4.6" (Non-Student)
					-- model = "grok-code-fast-1"
					-- model = "claude-haiku-4.5"
					-- model = "claude-sonnet-4.6" (Non-Student)
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "claude-haiku-4.5",
								},
							},
						})
					end,

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
								api_key = vim.env.GEMINI_API_KEY,
							},
						})
					end,

					----[[ Ollama (local + cloud); pick model with `ga` in chat ]]----
					-- Cloud models need OLLAMA_API_KEY; Authorization is sent only when the key is set.
					ollama = function()
						local models = {
							["qwen2.5-coder:7b"] = {
								formatted_name = "Qwen2.5 Coder 7B (local)",
							},
							["qwen2.5-coder:7b-base-q5_K_M"] = {
								formatted_name = "Qwen2.5 Coder 7B base q5_K_M (local)",
							},
							["qwen2.5-coder:7b-instruct-q5_K_M"] = {
								formatted_name = "Qwen2.5 Coder 7B instruct q5_K_M (local)",
							},
							["qwen3.5:9b-q4_K_M"] = {
								formatted_name = "Qwen3.5 9B q4_K_M (local)",
							},
							["qwen3.5:4b-q8_0"] = {
								formatted_name = "Qwen3.5 4B q8_0 (local)",
							},
							["qwen3-coder:480b-cloud"] = {
								formatted_name = "Qwen3 Coder 480B (cloud)",
							},
							["qwen3-coder-next:cloud"] = {
								formatted_name = "Qwen3 Coder Next (cloud)",
							},
							["devstral-2:123b-cloud"] = {
								formatted_name = "Devstral 2 123B (cloud)",
							},
							["gemini-3-pro-preview:latest"] = {
								formatted_name = "Gemini 3 Pro preview (cloud)",
							},
							["gemini-3-flash-preview:cloud"] = {
								formatted_name = "Gemini 3 Flash preview (cloud)",
							},
							["gemma4:31b-cloud"] = {
								formatted_name = "Gemma 4 31B (cloud)",
							},
							["gemma4:e4b"] = {
								formatted_name = "Gemma 4 e4B (local)",
							},
							["minimax-m2.7:cloud"] = {
								formatted_name = "Minimax M2.7 (cloud)",
							},
						}
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = function()
									return vim.env.OLLAMA_API_KEY
								end,
							},
							headers = {
								["Content-Type"] = "application/json",
								["Authorization"] = function(adapter)
									local key = adapter.env_replaced and adapter.env_replaced.api_key
									if type(key) == "string" and key ~= "" then
										return "Bearer " .. key
									end
									return nil
								end,
							},
							parameters = {
								sync = true,
							},
							schema = {
								model = {
									default = "qwen2.5-coder:7b-instruct-q5_K_M",
									choices = models,
								},
							},
						})
					end,

					-----[[ llama.cpp ]]-----
					llama_cpp = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = "http://127.0.0.1:8081",
								api_key = "TERM",
								chat_url = "/v1/chat/completions",
							},
							handlers = {
								parse_message_meta = function(data)
									local extra = data.extra
									if extra and extra.reasoning_content then
										data.output.reasoning = { content = extra.reasoning_content }
										if data.output.content == "" then
											data.output.content = nil
										end
									end
									return data
								end,
							},
						})
					end,

					-----[[ DeepSeek ]]-----
					deepseek = function()
						return require("codecompanion.adapters").extend("deepseek", {
							env = {
								url = "https://api.deepseek.com",
								api_key = vim.env.DEEPSEEK_API_KEY,
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = {
									default = "deepseek-v4-flash",
								},
								["thinking.type"] = {
									default = "enabled",
									optional = true,
								},
								reasoning_effort = {
									default = "max",
									optional = true,
								},
								temperature = {
									default = 1,
									optional = true,
								},
								top_p = {
									default = 1,
									optional = true,
								},
								max_tokens = {
									default = 8192,
									optional = true,
								},
							},
							handlers = {
								parse_message_meta = function(data)
									local extra = data.extra
									if extra and extra.reasoning_content then
										data.output.reasoning = { content = extra.reasoning_content }
										if data.output.content == "" then
											data.output.content = nil
										end
									end
									return data
								end,
							},
						})
					end,
				},
			},

			-----[[ Interactions ]] -----
			-- Interaction types:
			-- Chat     - A chat buffer where you can converse with an LLM (:CodeCompanionChat) (ACP only works here)
			-- Inline   - An inline assistant that can write code directly into a buffer (:CodeCompanion)
			-- Cmd      - Create Neovim commands in the command-line (:CodeCompanionCmd)
			-- Background - Runs tasks in the background such as compacting chat messages or generating titles for chats

			----- [[ Default Adapters For Each Interaction ]] -----
			interactions = {
				chat = {
					opts = {
						completion_provider = "cmp",
					},
					adapter = "opencode",
				},

				inline = {
					adapter = "opencode",
				},

				cmd = {
					adapter = "opencode",
				},

				background = {
					adapter = "opencode",
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
							---HTTP adapter only: ACP chats (e.g. cursor_cli) cannot generate titles
							adapter = "ollama",
							---Match http.adapters.copilot default; avoids reusing ACP model settings
							model = "gemma4:31b-cloud",
							---Number of user prompts after which to refresh the title (0 to disable)
							refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
							---Maximum number of times to refresh the title (default: 3)
							max_refreshes = 12,
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
								adapter = "ollama",
								model = "gemma4:31b-cloud",
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

		----------- [[ Autocmds ]] ---------
		-- Codecompanion specific chat buffer options
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt.scrolloff = 15
				vim.opt.wrap = true
			end,
		})

		-- Generate commit message inline when viewing staged diff
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitcommit",
			callback = function()
        -- Make 'q' quit the gitcommit ft buffer even if there are changes
				vim.keymap.set("n", "q", "<cmd>q!<CR>", { buffer = true, silent = true, nowait = true })

				if vim.b.codecompanion_commit_triggered then
					return
				end
				vim.b.codecompanion_commit_triggered = true
				vim.schedule(function()
					vim.api.nvim_command("CodeCompanion /commit-ptbr")
				end)
			end,
		})

		-- Keep chat buffer as fixed size
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.opt_local.winfixwidth = true
			end,
		})

		---------- [[ Keymaps ]] ----------
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
			local normal_width = math.floor(vim.o.columns * 0.23) -- match config default
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
			"<leader>ea",
			toggle_codecompanion_width,
			{ desc = "Toggle CodeCompanion chat width" }
		)

		-- Add agent skills string to CodeCompanion chat buffer -- Not working right now TODO fix
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.keymap.set({ "n" }, "gka", function()
					vim.fn.setreg(
						"+",
						"#{buffers}@{file_search}@{files}@{read_file}@{run_command}@{grep_search}@{get_diagnostics}@{agent}"
					)
					vim.cmd('normal! "+p')
					vim.cmd("normal! o")
				end, { desc = "Insert agent skills into chat", silent = true, buffer = true })
			end,
		})

		-- Add reading and file-finding skills, without the agent one
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function()
				vim.keymap.set({ "n" }, "gkr", function()
					vim.fn.setreg("+", "#{buffers}@{file_search}@{files}@{read_file}@{grep_search}@{get_diagnostics}")
					vim.cmd('normal! "+p')
					vim.cmd("normal! o")
				end, { desc = "Insert reading skills into chat", silent = true, buffer = true })
			end,
		})

		----- [[ Miscellaneous Configs ]] -----
		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
