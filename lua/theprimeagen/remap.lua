vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex);

vim.keymap.set("i", "jk", "<Esc>");
vim.keymap.set("i", "kj", "<Esc>");

vim.keymap.set("n", "<F9>", ":wq<CR>");
vim.keymap.set("n", "<leader><leader>", function() 
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>c", "<Cmd>!xclip -sel clip < %<CR>");
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true });
vim.keymap.set("n", "<leader>q", "<cmd>:q<CR>");

vim.keymap.set("n", "<leader>bd", function()
    vim.cmd("w");
    vim.cmd("bd");
end);
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>");
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>");
vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("botright new")
    vim.cmd("terminal")
    vim.cmd("resize 10");
    vim.opt.winfixheight = true;
    vim.opt.number = false; 
    vim.api.nvim_input('i');
end)

vim.keymap.set("t","<C-n>", "<C-\\><C-n>");
vim.keymap.set("n", "<leader>w", "<C-w>w");
