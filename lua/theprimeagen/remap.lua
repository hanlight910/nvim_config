-- === variables ===
local opt = { silent = true }

-- === modules ===
local c = require("templates.c");
local ok, fn = pcall(require, 'theprimeagen.functions');
-- === functions ===

if not ok then
	print("Function module is not loaded.");
	return 1;
end

local move_workspace = fn.move_workspace;
local create_fleeting_note = fn.create_fleeting_note;
local create_algorithm_path = fn.create_algorithm_path;
local open_terminal = fn.open_terminal;
local open_bash_config = fn.open_bash_config;
local run_c = fn.run_c;
local move_to_terminal_window = fn.move_to_terminal_window;
local move_to_next_normal_buffer = fn.move_to_next_normal_buffer;
local move_to_prev_normal_buffer = fn.move_to_prev_normal_buffer;
local delete_normal_buffer = fn.delete_normal_buffer;
local create_project = fn.create_project;

-- === Insert mode === 
vim.keymap.set("i", "jk", "<Esc>");
vim.keymap.set("i", "kj", "<Esc>");
vim.keymap.set("i", "<Tab>", "<Tab>");
vim.keymap.set("i", "<A-d>", "bdw");
vim.keymap.set("i", "<A-w>", "<cmd>w<CR>");

-- === normal mode ===
vim.keymap.set("n", "<leader>so", "<cmd>so " .. vim.g.config .. "/init.lua<CR>");
vim.keymap.set("n", "<leader>ca", "ggVG");
vim.keymap.set("n", "qq", function() vim.cmd("qa!") end);
vim.keymap.set("n", "<leader>io", "i{<Esc>ea}a");
vim.keymap.set("n", "<leader>anp", create_project);
vim.keymap.set("n", "<C-l>", move_workspace);
vim.keymap.set("n", "<A-q>", open_bash_config);
vim.keymap.set("n", "<leader>pp", "\"0p")
vim.keymap.set("n", "<leader>yy", "\"0y")
vim.keymap.set("n", "<A-y>", "\"+y");

vim.keymap.set("n", "<A-.>", move_to_terminal_window);
vim.keymap.set("n", "<C-j>", function ()
	print("Prev");
	move_to_prev_normal_buffer();
end);
vim.keymap.set("n", "<C-k>", move_to_next_normal_buffer);

vim.keymap.set("n", "<leader>xdg", "<cmd>!xdg-open \"%\"<CR>");
vim.keymap.set("n", "<leader>d", "vbd");
vim.keymap.set("n", "<leader>co", create_algorithm_path)
vim.keymap.set("n", "<leader>ctm", c.insert_c_template);
vim.keymap.set("n", "<F5>", run_c);

vim.keymap.set("n", "<F9>", ":wq<CR>");
vim.keymap.set("n", "<leader><leader>", function() 
	vim.cmd("so");
end)
vim.keymap.set("n", "<leader>cp", "<Cmd>!xclip -sel clip < %<CR>");
vim.keymap.set("n", "<leader>cl", "<Cmd>%d<CR>");
vim.keymap.set("n", "<leader>q", "<cmd>q!<CR>");

vim.keymap.set("n", "<leader>bd", delete_normal_buffer);

vim.keymap.set("n", "<leader>tt", open_terminal);

vim.keymap.set("n", "<A-=>", "<cmd>resize +5<CR>");
vim.keymap.set("n", "<A-->", "<cmd>resize -5<CR>");
vim.keymap.set("n", "<A-(>", "<cmd>vertical resize +10<CR>");
vim.keymap.set("n", "<A-)>", "<cmd>vertical resize -10<CR>");

vim.keymap.set("n", "<leader>w", "<C-w>");
vim.keymap.set("n", "<A-w>", "<cmd>w<Cr>");
vim.keymap.set("n", "<leader>nv", "<cmd>ex /home/light/archive/05-FLEETING/nvim_setting.md<CR>");
vim.keymap.set("n", "<A-s>", "<cmd>ex /home/light/.config/nvim/lua/theprimeagen/remap.lua<CR>");

vim.keymap.set("n", "<leader>al", "<cmd>ex /home/light/archive/06-DAILY/TIL/algorithm<CR>");
vim.keymap.set("n", "<leader>fl", create_fleeting_note, { noremap = true, silent = true })

-- vim.keymap.set("n", "<A-n>", "<cmd>bn<cr>");
-- vim.keymap.set("n", "<A-b>", "<cmd>bp<CR>");

vim.keymap.set("n", "<leader>ssu", "<cmd>ex " .. vim.g.ssu_path .. "<CR>")
vim.keymap.set("n", "<leader>pw", "<cmd>!pwd | xclip -sel clip<CR>", { silent = true, noremap = true });
vim.keymap.set("n", "<A-r>", "<C-r>");

-- === visual mode === 
vim.keymap.set("v", "<C-c>", "\"+y");
vim.keymap.set("v", "<leader>c", "\"+y <cmd>!silicon --build-cache --from-clipboard -l c --to-clipboard<CR>");

-- === Terminal mode ===
vim.keymap.set("t", "<A-=>", "<cmd>resize +5<CR>");
vim.keymap.set("t", "<A-->", "<cmd>resize -5<CR>");
vim.keymap.set("t", "<A-q>", "<C-\\><C-n><cmd>bd!<Cr>");
vim.keymap.set("t", "kj", "<C-\\><C-n>");
vim.keymap.set("t", "<C-l>", move_workspace);

