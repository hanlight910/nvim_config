vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>")
vim.keymap.set("n", "<leader>ga", "<cmd>Git add -A<CR>")
vim.keymap.set('n', '<leader>gp', '<cmd>Git push origin HEAD<CR>')
vim.keymap.set("n", "<leader>gr", function ()
	local grep_keyword = vim.fn.input("git grep > ");
	vim.cmd("Ggrep " .. grep_keyword);
end, {desc = "Git grep"});
