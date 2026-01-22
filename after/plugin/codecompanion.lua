local util = require('theprimeagen.utils');
local stat = util.safe_require("codecompanion");

if not stat then
	return nil;
end

local cocom = require("codecompanion");
local myprovider = "default"

cocom.setup({
	memory = {
		default = {
			description = "My default group",
			files = {
				"~/Downloads/notes.txt",
			},
		},
		opts = {
			chat = {
				default_memory = "default",
			},
		},
	},
	adapters = {
		-- 	openai = function()
		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				schema = {
					model = {
						default = "gemini-2.5-pro"
					},
				},
				env = {
					api_key = "GEMINI_API_KEY",
				},
			})
		end,
		openai_responses = function()
			return require("codecompanion.adapters").extend("openai", {
				schema = {
					model = {
						default = "gpt-4o",
					},
				},
				env = {
					api_key = os.getenv("OPENAI_API_KEY"),
				},
			})
		end,
		-- 		return co_adapters.extend("openai", {
		-- 			env = {
		-- 				api_key = os.getenv("OPENAI_API_KEY");
		-- 			},
		-- 		})
		-- 	end,
		-- 	llama3 = function()
		-- 		return co_adapters.extend("ollama", {
		-- 			name = "llama3.2", -- Give this adapter a different name to differentiate it from the default ollama adapter
		-- 			schema = {
		-- 				model = {
		-- 					default = "llama3.2:latest",
		-- 				},
		-- 				num_ctx = {
		-- 					default = 16384,
		-- 				},
		-- 				num_predict = {
		-- 					default = -1,
		-- 				},
		-- 			},
		-- 		})
		-- 	end,
	},
	strategies = {
		chat = {
			adapter = "gemini",
		},
		inline = {
			adapter = "openai"
		},
	},
	display = {
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ", -- Prompt used for interactive LLM calls
			provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
			opts = {
				show_default_actions = true, -- Show the default actions in the action palette?
				show_default_prompt_library = true, -- Show the default prompt library in the action palette?
				title = "CodeCompanion actions", -- The title of the action palette
			},
		},
		chat = {
			-- Change the default icons
			provider =  "default",
			show_tools_processing = true,
			separator = "─", -- The separator between the different messages in the chat buffer
			show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin

			statusline = {
				enabled = true,
				symbols = {
					loading = "…",     -- show while waiting
					generating = "⌛", -- show while streaming
					finished = "✔",
				},
			},
			icons = {
				buffer_pin = " ",
				buffer_watch = "👀 ",
				thinking = "⏳",   -- shows during LLM "thinking"
				streaming = "✍️", -- shows while tokens are streaming
				done = "✅",       -- after response is complete
			},

			-- Alter the sizing of the debug window
			debug_window = {
				---@return number|fun(): number
				width = vim.o.columns - 5,
				---@return number|fun(): number
				height = vim.o.lines - 2,
			},

			child_window = {
				width = vim.o.columns - 5,
				height = vim.o.lines - 2,
				row = "center",
				col = "center",
				relative = "editor",
				opts = {
					wrap = false,
					number = false,
					relativenumber = false,
				},
			},

			-- Options to customize the UI of the chat buffer
			window = {
				layout = "vertical", -- float|vertical|horizontal|buffer
				position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
				border = "single",
				height = 0.8,
				width = 0.5,
				relative = "editor",
				full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
				sticky = false, -- when set to true and `layout` is not `"buffer"`, the chat buffer will remain opened when switching tabs
				opts = {
					breakindent = false,
					cursorcolumn = false,
					cursorline = false,
					foldcolumn = "0",
					linebreak = true,
					list = false,
					numberwidth = 1,
					signcolumn = "no",
					spell = false,
					wrap = true,
				},
			},

			---Customize how tokens are displayed
			---@param tokens number
			---@param adapter CodeCompanion.Adapter
			---@return string
			token_count = function(tokens, adapter)
				return string.format(" (%d tokens)", tokens)
			end,
		},


	},
	prompt_library = {
		["Academic Writing"] = {
			strategy = "chat",
			description = "Evaluate phrases for academic writing style and suggest improvements.",
			opts = {
				index = 11,
				is_slash_cmd = true,
				auto_submit = false,
				short_name = "academic",
				ignore_system_prompt = true,
				system_prompt = function(opts)
					return [[
You are an academic writing assistant. 
Your task is to check input phrases for suitability in academic papers.
Be concise: highlight issues in grammar, clarity, and tone, and provide a short improved version.
Respond only in short, actionable points.
				]]
				end,
			},
			-- context = {
			-- 	{
			-- 		type = "file",
			-- 		path = {
			-- 			vim.g.areas .. "/prompt/academic_writing.md",
			-- 		},
			-- 	},
			-- },
			prompts = {
				{
					role =  "system",
					content = [[
					You are an academic writing evaluator. Your task is to review the input phrase
and provide concise feedback suitable for academic papers (e.g., recommendation
systems).
- Evaluate grammar, clarity, and academic tone.
- Point out issues in the phrase.
- Provide a corrected or improved version.
- Keep the response short and to the point.

Input phrase: {input_text}
Output format:
- Issues: <briefly list problems>
- Suggestion: <improved version>
You are an academic writing evaluator. 
Your task is to review the input phrase and provide concise feedback suitable for academic papers (e.g., recommendation systems).

Guidelines:
- Evaluate grammar, clarity, and academic tone.
- Point out issues in the phrase.
- Provide a corrected or improved version.
- Keep the response short and to the point.

Input phrase: {input_text}
Output format:
- Issues: <briefly list problems>
- Suggestion: <improved version>
]]

				},
				{
					role = "user",
					content = [[evaluate the following phrase for academic writing suitability. 
- Point out issues concisely (grammar, clarity, tone). 
- Suggest a corrected or improved version.
- Keep the response short and focused.

Phrase: {input_text}
]],
				},
			},
		},
	}
})

vim.keymap.set("n", "<leader>cc", function()
	require("codecompanion").prompt("academic")
end, { noremap = true, silent = true })

vim.keymap.set("v", "ga", function()


	-- <cmd>CodeCompanionChat Add<cr>"
	-- vim.cmd("CodeCompanionChat Add")
	
	-- copy visual selection to clipboard
	vim.cmd('normal! "+y')

	-- get the buffer that is name contains "CodeCompanion" that displayed

	local bufnr = -1
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		if name:match("CodeCompanion") then
			vim.api.nvim_set_current_win(win)
			break
		end
	end

	-- set to normal mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	-- paste from clipboard
	vim.cmd('normal! "+p')

	vim.api.nvim_input("<C-s>")


end, { noremap = true, silent = true })
