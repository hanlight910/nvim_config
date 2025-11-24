-- local ok, copilot = pcall(require, "copilot")
-- if ok then
require("copilot").setup({
	panel = {
		auto_refresh = false,
		keymap = {
			accept = "<cr>",
			jump_prev = "[[",
			jump_next = "]]",
			refresh = "gr",
			open = "<m-cr>",
		},
	},
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<a-o>",
			prev = "<c-j>",
			next = "<c-k>",
			-- dismis = "<c-]>",
		},
	},
	filetypes = {
		["*"] = true,  -- enable copilot for all file types
		["markdown"] = true,
		["text"] = true,  -- disable copilot for text files
	}
})
-- end

vim.keymap.set("i", "<c-k>k", "<cmd>Copilot detach<cr>", { noremap = true, silent = true })
vim.keymap.set("i", "<c-k>m", "<cmd>Copilot attach<cr>", { noremap = true, silent = true })

