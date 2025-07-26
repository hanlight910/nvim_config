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
			dismis = "<C-]>",
		},
	},
	filetypes = {
		["*"] = true,  -- Enable Copilot for all file types
		["markdown"] = true,
		["text"] = false,  -- Disable Copilot for text files
	}
})

