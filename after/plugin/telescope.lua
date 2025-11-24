local util = require('theprimeagen.utils'); 
local my_utils = require('theprimeagen.my_utils')
local stat = util.safe_require("telescope");

if not stat then
	return nil;
end

local ts = require("telescope")
local actions = require("telescope.actions")

local tb = require('telescope.builtin')
local fb_actions = require('telescope').extensions.file_browser.actions

local function open_file_browser(directory, depth)
	ts.extensions.file_browser.file_browser({
		cwd = directory,
		depth = depth,
	})
end

local function open_or_expand_dir(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	local path = entry and entry.Path and entry.Path:absolute() or nil

	if path and vim.fn.isdirectory(path) == 1 then
		-- Reopen with depth 10 if it's a directory
		open_file_browser(path, 10)
	else
		-- Open the file if selected
		fb_actions.open(prompt_bufnr)
	end
end
local function find_git_dir()
	local path = vim.fn.expand('%:p:h')  -- current file's directory
	for _ = 1, 10 do
		local git_path = path .. '/.git'
		if vim.fn.isdirectory(git_path) == 1 then
			return path
		end
		path = vim.fn.fnamemodify(path, ':h')  -- go up one level
	end
	return nil  -- not found
end

local function file_browse_git()
	local git_dir = find_git_dir()
	if git_dir ~= nil then
		vim.cmd("Telescope git_files")
	else

		vim.cmd("Telescope file_browser depth=10")
	end
end

vim.api.nvim_set_keymap('n', '<leader>df', '<cmd>Telescope lsp_type_definitions<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c>', '<cmd>Telescope oldfiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-g>', '<cmd>Telescope git_commits<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-f>', '<cmd>Telescope file_browser depth=10<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<A-f>', file_browse_git, { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-s>', '<cmd>Telescope file_browser path=' .. vim.g.nvim_config ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-q>', function()
	if my_utils.my_file.is_subpath_of_current_file("remote_ssh") then
		vim.cmd('Telescope file_browser path=' .. vim.g.remote_config .. ' select_buffer=true depth=10')
	else
		vim.cmd('Telescope file_browser path=' .. vim.g.bash_config .. ' select_buffer=true depth=10')
	end
end, { noremap = true, silent = true, desc = 'Browse notes directory' })
vim.api.nvim_set_keymap('n', '<A-z>', '<cmd>Telescope file_browser path=' .. vim.g.fleeting ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-a>', '<cmd>Telescope file_browser path=' .. vim.g.archive ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-r>', '<cmd>Telescope file_browser path=' .. vim.g.areas ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pap', '<cmd>Telescope file_browser path=' .. vim.g.projects ..  ' select_buffer=true depth=1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>Telescope file_browser path=' .. vim.g.project_1 .. ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>Telescope noice<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>td', '<cmd>Telescope lsp_definitions<CR>', { desc = "lsp_definitions", silent = true })
vim.keymap.set({ 'n' }, '<leader>tl', '<cmd>Telescope live_grep<CR>', { desc = "telescope live grep", silent = true })
vim.keymap.set({ 'n','i' }, '<A-i>', '<cmd>Telescope emoji<CR>', { desc = "telescope emoji", silent = true })

vim.keymap.set({ 'n' }, '<leader>tf', function()
	require('telescope.builtin').live_grep({
		search_dirs = { vim.g.archive },
	})
end, { desc = "telescope live grep in specific dir", silent = true })

vim.keymap.set({ 'n' }, '<leader>tw', '<cmd>Telescope buffers<CR>', { desc = "telescope live grep", silent = true })
vim.keymap.set({ 'n' }, '<leader>th', '<cmd>Telescope git_branches<CR>', { desc = "telescope git branches", silent = true })

ts.setup({
	defaults = {
		path_display = { "truncate" },  -- show full path from left, truncating from the right if too long
		file_ignore_patterns = {
			"%.git/*",
			"venv",
			"node_modules",
			"__pycache__",
			".pytest_cache",
		},  -- Exclude .git directory,
	},
	theme = "ivy",
	extensions = {
		file_browser = {
			theme = "ivy",
			hidden = true,
			autodepth = true,
			mappings = {
				["i"] = {
					["<bs>"] = false,       -- Disable backspace navigation
					["h"] = false,          -- Disable 'h' (go up one level)
					-- ["<CR>"] =open_or_expand_dir,
				},
				["n"] = {
					["-"] = false,          -- Disable '-' (navigate up)
					["o"] = function(prompt_bufnr)
						local entry = require("telescope.actions.state").get_selected_entry()
						local filepath = entry.path
						vim.fn.jobstart({ "xdg-open", filepath }, { detach = true })
						actions.close(prompt_bufnr)
					end,
				},
			},
		},
	},
	fzf = {
		fuzzy = true,                    -- false will only do exact matching
		override_generic_sorter = true,  -- override the generic sorter
		override_file_sorter = true,     -- override the file sorter
		case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
		-- the default case_mode is "smart_case"
	}
});
ts.load_extension("file_browser");
ts.load_extension("emoji");
ts.load_extension('fzf');

vim.keymap.set("n", "<leader>fl", function ()
	-- open_file_browser(f)
	local currentPath = vim.fn.getcwd()
	-- Find the position of the last "lib" in the path
	local lib_index = currentPath:reverse():find("bil")  -- Reverse and find "lib" ("/bil")
	if lib_index then
		-- Get the position of the last "lib"
		local final_index = #currentPath - lib_index + 1
		local truncated_path = currentPath:sub(1, final_index)
		print("current Path: " .. currentPath)
		print(truncated_path);
		open_file_browser(truncated_path, 10)
	end
end)

vim.keymap.set("n", "<leader>dl", function ()
	local uv = vim.loop
	local sep = package.config:sub(1, 1)
	local path = vim.fn.expand("%:p")
	local depth = 0
	local max_depth = 5

	while path and path ~= sep and depth < max_depth do
		local parent_doc = path .. sep .. "doc"
		if uv.fs_stat(parent_doc) and uv.fs_stat(parent_doc).type == "directory" then
			print("Found 'doc' directory at: " .. parent_doc)
			open_file_browser(parent_doc, 10)
			return
		end
		-- Move one level up
		path = path:match("^(.*)" .. sep .. "[^" .. sep .. "]+$")
		depth = depth + 1
	end

	print("'doc' directory not found in parent hierarchy (up to 3 levels)")
end)


vim.keymap.set("n", "<leader>fd", function()
	local sep = package.config:sub(1, 1)
	local path = vim.fn.expand("%:p:h")
	local depth = 2

	-- Traverse 5 levels up
	for _ = 1, depth do
		local parent = path:match("^(.*)" .. sep .. "[^" .. sep .. "]+$")
		if not parent or parent == "" then break end
		path = parent
		print("Current path: " .. path)
	end

	-- Now open file browser from that path with depth=5
	require("telescope").extensions.file_browser.file_browser({
		cwd = path,
		depth = depth,
	})
end, { desc = "Browse from 5-level-up parent (depth=5)", silent = true })

vim.keymap.set("n", "<A-t>", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP Document Symbols", silent = true })

-- my_utils.my_file.is_subpath_of_current_file("areas")
