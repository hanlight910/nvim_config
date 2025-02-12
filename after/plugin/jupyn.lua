require("jupynium").setup({
	--- For Conda environment named "jupynium",
	-- python_host ={ "conda", "run", "--no-capture-output", "-n", "jupynium", "python" },

	default_notebook_URL = "localhost:8888/nbclassic",
	python_host = "conda",
	jupyter_command = "conda",

	-- Write jupyter command but without "notebook"
	-- When you call :JupyniumStartAndAttachToServer and no notebook is open,
	-- then Jupynium will open the server for you using this command. (only when notebook_URL is localhost)
	--- For Conda, maybe use base environment
	--- then you can `conda install -n base nb_conda_kernels` to switch environment in Jupyter Notebook
	-- jupyter_command = { "conda", "run", "--no-capture-output", "-n", "base", "jupyter" },

	-- Used when notebook is launched by using jupyter_command.
	-- If nil or "", it will open at the git directory of the current buffer,
	-- but still navigate to the directory of the current buffer. (e.g. localhost:8888/nbclassic/tree/path/to/buffer)
	notebook_dir = nil,

	-- Used to remember the last session (password etc.).
	-- e.g. '~/.mozilla/firefox/profiles.ini'
	-- or '~/snap/firefox/common/.mozilla/firefox/profiles.ini'
	firefox_profiles_ini_path = nil,
	-- nil means the profile with Default=1
	-- or set to something like 'default-release'
	firefox_profile_name = nil,

	-- Open the Jupynium server if it is not already running
	-- which means that it will open the Selenium browser when you open this file.
	-- Related command :JupyniumStartAndAttachToServer
	auto_start_server = {
		enable = true,
		file_pattern = { "*.ju.*" },
	},

	-- Attach current nvim to the Jupynium server
	-- Without this step, you can't use :JupyniumStartSync
	-- Related command :JupyniumAttachToServer
	auto_attach_to_server = {
		enable = false,
		file_pattern = { "*.ju.*", "*.md" },
	},

	-- Automatically open an Untitled.ipynb file on Notebook
	-- when you open a .ju.py file on nvim.
	-- Related command :JupyniumStartSync
	auto_start_sync = {
		enable = false,
		file_pattern = { "*.ju.*", "*.md" },
	},

	-- Automatically keep filename.ipynb copy of filename.ju.py
	-- by downloading from the Jupyter Notebook server.
	-- WARNING: this will overwrite the file without asking
	-- Related command :JupyniumDownloadIpynb
	auto_download_ipynb = false,

	-- Automatically close tab that is in sync when you close buffer in vim.
	auto_close_tab = true,

	-- Always scroll to the current cell.
	-- Related command :JupyniumScrollToCell
	autoscroll = {
		enable = true,
		mode = "always", -- "always" or "invisible"
		cell = {
			top_margin_percent = 20,
		},
	},

	scroll = {
		page = { step = 0.5 },
		cell = {
			top_margin_percent = 20,
		},
	},

	-- Files to be detected as a jupynium file.
	-- Add highlighting, keybindings, commands (e.g. :JupyniumStartAndAttachToServer)
	-- Modify this if you already have lots of files in Jupytext format, for example.
	jupynium_file_pattern = { "*.ju.*" },

	use_default_keybindings = true,
	textobjects = {
		use_default_keybindings = true,
	},

	syntax_highlight = {
		enable = true,
	},

	-- Dim all cells except the current one
	-- Related command :JupyniumShortsightedToggle
	shortsighted = false,

	-- Configure floating window options
	-- Related command :JupyniumKernelHover
	kernel_hover = {
		floating_win_opts = {
			max_width = 84,
			border = "none",
		},
	},

	notify = {
		ignore = {
			-- "download_ipynb",
			-- "error_download_ipynb",
			-- "attach_and_init",
			-- "error_close_main_page",
			-- "notebook_closed",
		},
	},
})

-- You can link highlighting groups.
-- This is the default (when colour scheme is unknown)
-- Try with CursorColumn, Pmenu, Folded etc.
vim.cmd [[
hi! link JupyniumCodeCellSeparator CursorLine
hi! link JupyniumMarkdownCellSeparator CursorLine
hi! link JupyniumMarkdownCellContent CursorLine
hi! link JupyniumMagicCommand Keyword
]]


function startJupyter ()
	local nvim_server_name = vim.v.servername;
	
	vim.g.open_terminal();
	vim.api.nvim_input("cd ..<CR>");
	vim.api.nvim_input(". ./venv/bin/activate<CR>");
	vim.api.nvim_input("jupynium --nvim_listen_addr " .. nvim_server_name .. "<CR>");
	local timer = vim.uv.new_timer();
	
	-- after the above lines executed then move to other window
	timer:start(5000, 0, function ()
		vim.schedule(
			function ()
				vim.g.move_workspace();
				-- vim.api.nvim_input(":JupyniumStartSync<CR>");
				vim.cmd("JupyniumStartSync");
			end
		)
		print("passed");
	end)
end

function executeAllCell()
	local current_buf = vim.api.nvim_get_current_buf();
	local file_name = vim.api.nvim_buf_get_name(current_buf);

	if not file_name:match("%.ju%.py$") then
		print("Is not `*.ju.py` format.");
		return nil;
	end
	vim.api.nvim_input("ggVG");
	vim.api.nvim_input("<cmd>JupyniumExecuteSelectedCells<CR>");
	vim.api.nvim_input("<Esc>");
	print("All cell executed.");
end
vim.keymap.set("n", "<leader>jn", startJupyter) -- Please share your favourite settings on other colour schemes, so I can add defaults. Currently, tokyonight is supported.
vim.keymap.set("n", "<leader>ja", executeAllCell);

function test()
	vim.api.nvim_input("ggVG");
end
-- vim.keymap.set({"n", "i"}, "test", test);
