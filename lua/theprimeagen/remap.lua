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

local run = fn.run;
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
vim.keymap.set("i", "<C-v>", function ()
	return "![]" .. "(" .. vim.fn.getreg("+") .. ")";
end, { expr = true });


vim.keymap.set({"i"}, "\\", function ()
	if fn.in_matrix() then
		print("yes")
		return "\\\\<CR>"
	else
		print("not")
		return "\\"
	end
end, { expr = true });

-- === normal mode ===
-- vim.keymap.set({"n"}, "<A-e>", ":ex " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"), {desc="create new file"})
vim.keymap.set({"n"}, "<A-e>", ":ex " .. vim.api.nvim_buf_get_name(0), {desc="create new file"})
vim.keymap.set({"n"}, "<leader>cc", function ()
	local line = vim.api.nvim_get_current_line()
	-- Extract the path inside parentheses ()
	local path = string.match(line, "%(([^)]+)%)")
	if path == nil then
		vim.notify("No path found under cursor", vim.log.levels.ERROR)
		return
	end

	-- Run xclip command to copy the file content
	local cmd = string.format("xclip -selection clipboard -t image/png -i '%s'", path)
	vim.fn.jobstart(cmd, { detach = true })
end)
vim.keymap.set({"n"}, "<leader>dd", "/\\d<CR>")
vim.keymap.set({"n"}, "<leader>{", "V{\"+y}")
vim.keymap.set({"n"}, "<leader>}", "V}\"+y")
vim.keymap.set({"n"}, "<A-k>", "ex " .. vim.g.vim_note .. "<CR>")
vim.keymap.set({"n"}, "<Up>", "<C-w>k");
vim.keymap.set({"n"}, "<Down>", "<C-w>j");
vim.keymap.set({"n"}, "<Left>", "<C-w>j");
vim.keymap.set({"n"}, "<Right>", "<C-w>l");
vim.keymap.set({ "n" } , "<leader>fx", function ()
	local filename = vim.fn.expand("%");
	print(filename)
	local result = vim.fn.system({"chmod", "+x", filename});
	print(result)
end , { desc = "Append permission executable" });
vim.keymap.set({ "n" }, "<leader>r", "<cmd>e!<cr>", { desc = "Reload" });
vim.keymap.set({ "n", "v" }, "<leader>ps", "<cmd>PackerSync<CR>", { desc = "Packer Sync" })
vim.keymap.set({ "n", "v" }, "+", "<C-a>", { desc = "Increment number "});
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrease number "});
vim.keymap.set("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>")
vim.keymap.set("n", "<leader>so", "<cmd>so ".. "<CR>");
vim.keymap.set("n", "<leader>ca", "ggVG");
vim.keymap.set("n", "<leader>ci", "ggVG=<C-O>");
vim.keymap.set("n", "qq", function() vim.cmd("qa!") end);
vim.keymap.set("n", "<leader>io", "i{<Esc>ea}a");
vim.keymap.set("n", "<leader>anp", create_project);
vim.keymap.set("n", "<C-l>", move_workspace);
vim.keymap.set("n", "<leader>pp", "\"0p")
vim.keymap.set("n", "<leader>yy", "\"0y")
vim.keymap.set("n", "<A-y>", "\"+y");

vim.keymap.set("n", "<C-l>", move_to_terminal_window);
vim.keymap.set("n", "<C-j>", function ()
	move_to_prev_normal_buffer();
end);
vim.keymap.set("n", "<C-k>", move_to_next_normal_buffer);

vim.keymap.set("n", "<leader>oo", "<cmd>!open \"%\"<CR>");
vim.keymap.set("n", "<leader>co", create_algorithm_path)
vim.keymap.set("n", "<leader>ctm", c.insert_c_template);
vim.keymap.set("n", "<F5>", run);

vim.keymap.set("n", "<F9>", ":wq<CR>");
vim.keymap.set("n", "<leader><leader>", function() 
	vim.cmd("so");
end)
vim.keymap.set("n", "<leader>cp", function ()
	local lin, col = unpack(vim.api.nvim_win_get_cursor(0));
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false);
	local content = table.concat(lines, '\n');
	vim.fn.setreg('+', content);
	vim.api.nvim_win_set_cursor(0, {lin, col})
end, { desc = "Copy all" });
vim.keymap.set("n", "<leader>cl", "<Cmd>%d<CR>");
vim.keymap.set("n", "<leader>q", "<cmd>q!<CR>");

vim.keymap.set("n", "<A-x>", delete_normal_buffer);

vim.keymap.set("n", "<leader>tt", open_terminal);

vim.keymap.set("n", "<C-Down>", "<cmd>resize +5<CR>");
vim.keymap.set("n", "<C-Up>", "<cmd>resize -5<CR>");
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +10<CR>");
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -10<CR>");

vim.keymap.set("n", "<leader>w", "<C-w>");
vim.keymap.set("n", "<A-w>", "<cmd>w<Cr>");
vim.keymap.set("n", "<leader>nv", "<cmd>ex /home/light/archive/05-FLEETING/nvim_setting.md<CR>");

vim.keymap.set("n", "<leader>al", "<cmd>ex /home/light/archive/06-DAILY/TIL/algorithm<CR>");
-- vim.keymap.set("n", "<A-n>", "<cmd>bn<cr>");
-- vim.keymap.set("n", "<A-b>", "<cmd>bp<CR>");

vim.keymap.set("n", "<leader>pw", function ()
	local pwd = vim.fn.expand("%:p");
	vim.fn.setreg("+", pwd);
end, { desc = "Copy path", silent = true, noremap = true });
vim.keymap.set("n", "<A-r>", "<C-r>");

-- === visual mode === 
vim.keymap.set('v', '<leader>h', function()
	-- Get the start and end of the visual selection
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	-- Build the pattern
	local pattern = ""
	for line = start_line, end_line do
		pattern = pattern .. "\\%" .. line .. "l.*\\|"
	end
	-- Remove the last '\|' (extra OR)
	pattern = pattern:sub(1, -3)

	-- Apply match
	vim.cmd('match Search /' .. pattern .. '/')

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', false)
end, { desc = "Highlight Visual Lines" })

vim.keymap.set("v", "<C-c>", "\"+y");

-- vim.keymap.set("v", "<leader>si", "\"+y <cmd>!silicon --from-clipboard -l c --to-clipboard<CR>");
vim.keymap.set("v", "<leader>si", function()
	vim.cmd('normal! "+y')
	local filename = vim.api.nvim_buf_get_name(0)
	local extension = filename:match("^.+%.([^.]+)$")

	print("File extension:", extension)


	print("File extension:", extension)
	vim.fn.system('customsilicon.sh ' .. extension)

end, { desc = "Save selection as image and copy path", silent = true })


-- === Terminal mode ===
vim.keymap.set("t", "<A-=>", "<cmd>resize +5<CR>");
vim.keymap.set("t", "<A-->", "<cmd>resize -5<CR>");
vim.keymap.set("t", "<A-q>", "<C-\\><C-n><cmd>bd!<Cr>");
vim.keymap.set("t", "kj", "<C-\\><C-n>");
vim.keymap.set("t", "<C-l>", move_workspace);
