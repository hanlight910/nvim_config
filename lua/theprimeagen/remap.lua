local c = require("theprimeagen.templates.c");
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex);
vim.keymap.set("n", "<leader>ctm", c.insert_c_template);

vim.keymap.set("i", "jk", "<Esc>");
vim.keymap.set("i", "kj", "<Esc>");
vim.keymap.set("i", "lk", "<Esc>la");
vim.keymap.set("i", "kl", "<Esc>la");

vim.keymap.set("n", "<F9>", ":wq<CR>");
vim.keymap.set("n", "<leader><leader>", function() 
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>cp", "<Cmd>!xclip -sel clip < %<CR>");
vim.keymap.set("n", "<leader>cl", "<Cmd>%d<CR>");
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true });
vim.keymap.set("n", "<leader>q", "<cmd>q!<CR>");

vim.keymap.set("n", "<leader>bd", function()
    vim.cmd("bd!");
    vim.cmd("bn");
end);

vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>");
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>");
vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("botright new");
    vim.opt.number = false;
    vim.opt.relativenumber = false;
    vim.cmd("terminal");
    vim.cmd("resize 10");
    vim.opt.winfixheight = true;
    vim.api.nvim_input('i');
end)


vim.keymap.set("n", "<leader>dbr", function() 
    -- Get the current file path
    local filepath = vim.fn.expand("%:p")

    -- Compile the C file
    local compile_command = "gcc -g " .. filepath .. " -o output"
    vim.cmd("!" .. compile_command)

    -- Check if compilation was successful
    if vim.v.shell_error == 0 then
        -- Open gdb with the compiled output
        vim.cmd("!gdb ./output")
    else
        print("Compilation failed.")
    end
end, { noremap = true, silent = true })

vim.keymap.set("i", "<Tab>", "<Tab>");
vim.keymap.set("t", "<A-=>", "<cmd>resize +5<CR>");
vim.keymap.set("t", "<A-->", "<cmd>resize -5<CR>");
vim.keymap.set("n", "<A-=>", "<cmd>resize +5<CR>");
vim.keymap.set("n", "<A-->", "<cmd>resize -5<CR>");
vim.keymap.set("t","<C-n>", "<C-\\><C-n>");
vim.keymap.set("t", "<A-q>", "<C-\\><C-n><cmd>bd!<Cr>");
vim.keymap.set("t", "kj", "<C-\\><C-n>");

vim.keymap.set("n", "<leader>w", "<C-w>w");
vim.keymap.set("n", "<A-w>", "<cmd>w<Cr>");

vim.keymap.set("v", "kj", "<Esc>");
vim.keymap.set("v", "jk", "<Esc>");

