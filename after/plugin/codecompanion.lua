local util = require('theprimeagen.utils');


local stat = util.safe_require("codecompanion");

if not stat then
	return nil;
end

local cocom = require("codecompanion");
local co_adapters = require("codecompanion.adapters");

cocom.setup({
	adapters = {
		openai = function()
			return co_adapters.extend("openai", {
				env = {
					api_key = os.getenv("OPENAI_API_KEY");
				},
			})
		end,
		llama3 = function()
			return co_adapters.extend("ollama", {
				name = "llama3.2", -- Give this adapter a different name to differentiate it from the default ollama adapter
				schema = {
					model = {
						default = "llama3.2:latest",
					},
					num_ctx = {
						default = 16384,
					},
					num_predict = {
						default = -1,
					},
				},
			})
		end,
	},
	strategies = {
		chat = {
			adapter = "openai",
		},
		inline = {
			adapter = "openai",
		},
	},
})
