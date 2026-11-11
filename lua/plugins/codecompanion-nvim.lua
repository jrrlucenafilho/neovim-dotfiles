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
				---[[ acp protocol ]]---
				acp = {
					opts = {
						show_presets = false,
					},

					----- [[ cursor cli ]] -----
					-- models come from the agent via acp (`session/update`); pick them with `ga` in chat.
					-- only `defaults.model` is read for acp (see codecompanion's 'gd' debug buffer when cursor_cli is sselected).
					-- the standart model here is empty, so cursor itself decides it (desire behavior for now)
					-- and the ui models list comes from what models cursor exposes through acp
					cursor_cli = function()
						return require("codecompanion.adapters").extend("cursor_cli", {
							defaults = {
								session_config_options = {
									model = "auto",
								},
							},
						})
					end,

					----- [[ claude code ]] -----
					--- install claude-agent-acp (aur)
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							defaults = {
								session_config_options = {
									model = "deepseek-v4.1-flash",
									thought_level = "high",
								},
							},
						})
					end,

					----- [[ opencode ]] -----
					opencode = function()
						return require("codecompanion.adapters").extend("opencode", {
							defaults = {
								session_config_options = {
									model = "deepseek/deepseek v4.1 flash 1017",
									thought_level = "high",
								},
							},
						})
					end,

					----- [[ Deepseek Harness (Custom) ]] -----
					-- deepseek_harness = function()
					-- 	return {
					-- 		name = "deepseek_harness",
					-- 		formatted_name = "DeepSeek Harness Agent",
					-- 		type = "acp",
					-- 		roles = {
					-- 			llm = "assistant",
					-- 			user = "user",
					-- 		},
					-- 		commands = {
					-- 			default = { "dsh", "--profile", "acp" },
					-- 		},
					-- 		defaults = {
					-- 			model = "deepseek-v4.1-flash",
					-- 			timeout = 30000, -- Await fot the JSON-RPC handshake
					-- 		},
					-- 		handlers = {
					-- 			setup = function(self)
					-- 				return true
					-- 			end,
					-- 			auth = function(self)
					-- 				return true
					-- 			end,
					-- 		},
					-- 		parameters = {
					-- 			protocolVersion = 1,
					-- 			clientCapabilities = {
					-- 				fs = { readTextFile = true, writeTextFile = true },
					-- 			},
					-- 			clientInfo = {
					-- 				name = "CodeCompanion.nvim",
					-- 				version = "1.0.0",
					-- 				env = {
					-- 					DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY"),
					-- 				},
					-- 			},
					-- 		},
					-- 	}
					-- end,
				},

				----[[ http protocol ]]----
				http = {
					opts = {
						show_presets = false,
					},

					-- ----- [[ github copilot ]]-----
					-- model names for copilot provider:
					-- check rates here: https://docs.github.com/en/copilot/reference/ai-models/supported-models
					-- model = "gpt-4.1",
					-- model = "claude-sonnet-4.5" (non-student)
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
					-- model = "claude-opus-4.5" (non-student)
					-- model = "gpt-5.2"
					-- model = "oswe-vscode-prime"
					-- model = "gpt-4o"
					-- model = "gpt-5.3-codex"
					-- model = "claude-sonnet-4" (non-student)
					-- model = "gpt-5.1"
					-- model = "claude-opus-4.6" (non-student)
					-- model = "grok-code-fast-1"
					-- model = "claude-haiku-4.5"
					-- model = "claude-sonnet-4.6" (non-student)
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "claude-haiku-4.5",
								},
							},
						})
					end,

					-----[[ gemini ]]-----
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = "gemini-2.5-flash",
									-- default = "gemini-2.5-flash-lite", -- choose one
								},
							},
							env = {
								api_key = vim.env.gemini_api_key,
							},
						})
					end,

					----[[ ollama local models]]----
					ollama = function()
						local models = {
							["qwen3.5:0.8b"] = {
								formatted_name = "qwen3.5 0.8b",
							},
							["qwen3.5:2b"] = {
								formatted_name = "qwen3.5 2b",
							},
							["qwen3.5:4b"] = {
								formatted_name = "qwen3.5 4b",
							},
						}
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://localhost:11434",
								api_key = function()
									return vim.env.ollama_api_key
								end,
							},
							headers = {
								["content-type"] = "application/json",
								["authorization"] = function(adapter)
									local key = adapter.env_replaced and adapter.env_replaced.api_key
									if type(key) == "string" and key ~= "" then
										return "bearer " .. key
									end
									return nil
								end,
							},
							parameters = {
								sync = true,
							},
							schema = {
								model = {
									default = "qwen3.5:0.8b",
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
								api_key = "term",
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

					-----[[ deepseek ]]-----
					deepseek = function()
						return require("codecompanion.adapters").extend("deepseek", {
							env = {
								url = "https://api.deepseek.com",
								api_key = vim.env.deepseek_api_key,
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = {
									default = "deepseek-v4.1-flash",
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
					adapter = "deepseek",
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
							model = "qwen3.5:0.8b",
							---Number of user prompts after which to refresh the title (0 to disable)
							refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
							---Maximum number of times to refresh the title (default: 3)
							max_refreshes = 12,
							format_title = function(original_title)
								-- this can be a custom function that applies some custom
								-- formatting to the title.
								-- The local model sometimes returns multi-line titles. Keep them
								-- single-line so telescope can render them (see note below).
								return (original_title:gsub("[\r\n]+", " "):gsub("%s+$", ""))
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
								model = "qwen3.5:0.8b",
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

		-- Auto-generated chat titles occasionally contain newlines (the local title
		-- model is not reliable). Telescope renders each result as a single buffer
		-- line, so a multi-line title makes its descending-sort entry inserter drop a
		-- results line and then fail with "Invalid cursor line: out of range" from
		-- `telescope/pickers.lua` (`get_result_completor`) whenever you type in the
		-- `gh` history picker. Flatten titles at display time so old saved chats are
		-- fixed too, not just newly generated ones.
		local ok, history_picker = pcall(require, "codecompanion._extensions.history.pickers.default")
		if ok then
			local get_item_title = history_picker.get_item_title
			history_picker.get_item_title = function(self, item)
				return (tostring(get_item_title(self, item)):gsub("[\r\n]+", " "))
			end
		end

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

		-- Generate commit message from llm and yank it to clipboard
		local yank_next_chat_response = false

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "NeogitDiffView",
			callback = function()
				yank_next_chat_response = true
				vim.api.nvim_command("CodeCompanion /commit-ptbr")
			end,
		})

		-- Responsible for yanking the commit message
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionChatDone",
			callback = function(args)
				if not yank_next_chat_response then
					return
				end
				yank_next_chat_response = false

				local chat = require("codecompanion").buf_get_chat(args.data.bufnr)
				if not chat then
					return
				end

				for i = #chat.messages, 1, -1 do
					local msg = chat.messages[i]
					if msg.role == "llm" and type(msg.content) == "string" and msg.content ~= "" then
						vim.fn.setreg('"', msg.content)
						vim.notify(
							"Commit message yanked to clipboard!",
							vim.log.levels.INFO,
							{ title = "CodeCompanion" }
						)
						break
					end
				end
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

		-- Add agent skills string to CodeCompanion chat buffer
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
