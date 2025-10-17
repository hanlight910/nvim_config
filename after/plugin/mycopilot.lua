-- local ok, copilot = pcall(require, "copilot")
-- if ok then
require("copilot").setup({
	panel = {
		auto_refresh = false,
		keymap = {
			accept = "<CR>",
			jump_prev = "[[",
			jump_next = "]]",
			refresh = "gr",
			open = "<M-CR>",
		},
	},
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<A-o>",
			prev = "<C-j>",
			next = "<C-k>",
			-- dismis = "<C-]>",
		},
	},
	filetypes = {
		["*"] = true,  -- Enable Copilot for all file types
		["markdown"] = false,
		["text"] = true,  -- Disable Copilot for text files
	}
})
-- end

