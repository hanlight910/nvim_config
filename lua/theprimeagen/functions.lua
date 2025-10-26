
local functions = {}

--- ==== assist ====
local function check_file_format()
	local file_type = vim.bo.filetype;
	print(file_type);
	return file_type;
end

functions.copy_code_as_image_to_clipboard = function()
	local file_format = vim.fn.expand("%:e");
	local mode_info = vim.api.nvim_get_mode();
	local current_mode = mode_info.mode;
	if current_mode == 'v' or current_mode == 'V' then
		local _, st_lnum, st_col = unpack(vim.fn.getpos("'<"));
		local _, en_lnum, en_col = unpack(vim.fn.getpos("'>"));
		local lines = vim.api.nvim_buf_get_lines(0, st_lnum - 1, en_lnum, false);
		local text = table.concat(lines, '\n');
		vim.fn.setreg('+', text);
	else

	end
	vim.cmd("!silicon --from-clipboard -l " .. file_format .. " --to-clipboard");
end

vim.api.nvim_create_user_command('SplitCmd', function(opts)
	-- Disable Noice temporarily
	local noice_enabled = vim.g.noice_running
	if noice_enabled then
		vim.cmd('Noice disable') -- Turn Noice off
	end

	-- Create a temporary scratch buffer in a new split
	vim.cmd('new')
	local buf = vim.api.nvim_get_current_buf()

	-- Set buffer options to make it temporary
	vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')   -- Delete buffer on close
	vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')   -- No associated file
	vim.api.nvim_buf_set_option(buf, 'swapfile', false)     -- No swap file
	vim.api.nvim_buf_set_option(buf, 'modifiable', true)    -- Allow editing (if needed)

	-- Run the command and fill the buffer with output
	local output = vim.fn.execute(opts.args)

	-- Re-enable Noice
	if noice_enabled then
		vim.cmd('Noice enable')
	end
end, { nargs = 1, complete = 'command' })


-- ==== window navigation ====
functions.move_workspace = function()
	local windows = vim.api.nvim_list_wins()

	for _, win in ipairs(windows) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
		local buflisted = vim.api.nvim_buf_get_option(buf, "buflisted")
		local bufname = vim.api.nvim_buf_get_name(buf)

		if buftype == "" and (buflisted or vim.api.nvim_buf_is_valid(buf) and bufname ~= "") then
			vim.api.nvim_set_current_win(win)
			print("Moved to active or listed window")
			return
		end
	end
end

functions.move_to_terminal_window = function()
	print("Moving to terminal window...")

	-- Get the list of all open windows
	local windows = vim.api.nvim_list_wins()

	-- Iterate over all windows
	for _, win in ipairs(windows) do
		-- Get the buffer associated with the current window
		local buf = vim.api.nvim_win_get_buf(win)

		-- Check if the buffer is a terminal
		local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
		if buftype == "terminal" then
			-- Move the cursor to the window displaying the terminal
			vim.api.nvim_set_current_win(win)
			print("Moved to terminal window")
			vim.cmd("startinsert");
			return
		end
	end

	print("No terminal window found")
end

--- moving buffer
functions.move_to_next_normal_buffer = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()
	local found = false

	for i, buf in ipairs(buffers) do
		if buf == current_buf then
			found = true -- Found the current buffer, start checking next
		elseif found and vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

			if buftype == "" and filetype ~= "terminal" then
				-- Switch to the buffer
				vim.api.nvim_set_current_buf(buf);
				return
			end
		end
	end

	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

			if buftype == "" and filetype ~= "terminal" then
				vim.api.nvim_set_current_buf(buf)
				return
			end
		end
	end
end

functions.delete_normal_buffer = function()
	local current_buf = vim.api.nvim_get_current_buf()
	-- local buffers = vim.api.nvim_list_bufs()
	-- local normal_buffer = nil

	-- for _, buf in ipairs(buffers) do
	--     local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
	--     if buftype == "" and buf ~= current_buf then
	--         normal_buffer = buf
	--         break
	--     end
	-- end

	functions.move_to_next_normal_buffer();
	vim.api.nvim_buf_delete(current_buf, { force = true })
end

functions.move_to_prev_normal_buffer = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()
	local found = false

	-- Start from the current buffer and move backwards
	for i = #buffers, 1, -1 do
		local buf = buffers[i]
		if buf == current_buf then
			found = true  -- Start checking the previous buffer
		elseif found and vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

			-- Check if it's not a terminal and is a normal file
			if buftype == "" and filetype ~= "terminal" then
				-- Switch to the buffer
				vim.api.nvim_set_current_buf(buf)
				return
			end
		end
	end

	-- If no normal file buffer is found, wrap around to the end
	for i = #buffers, 1, -1 do
		local buf = buffers[i]
		if vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

			-- Check if it's not a terminal and is a normal file
			if buftype == "" and filetype ~= "terminal" then
				vim.api.nvim_set_current_buf(buf)
				return
			end
		end
	end

	print("No suitable normal file buffer found")
end

local current_terminal_index = 0

local current_terminal_index = 0


--- creating files
functions.create_fleeting_note = function ()
	local input = vim.fn.input("Enter filename: ");
	local dir = "/home/light/archive/05-FLEETING/"
	local file_path = dir .. input
	vim.cmd("e " .. file_path);
	return 0;
end

functions.create_algorithm_path = function()
	local file_name = vim.fn.expand("%:t:r");
	local new_file_path = vim.g.baekjoon .. "/" .. file_name;
	local input_value = vim.fn.input("file extension: ") print("new file path: " .. new_file_path);
	vim.cmd("!mkdir " .. new_file_path);
	vim.cmd("ex " .. new_file_path .. "/code." .. input_value);
	return 0;
end

functions.create_project = function()
	local input = vim.fn.input("Enter project name: ");
	local dir = vim.g.projects;
	local dir_path = dir .. input;
	vim.cmd("!mkdir " .. dir_path);
	vim.cmd("e " .. dir_path);
	return 0;
end

--- compile
functions.compile_c = function()
	local file_name = vim.fn.expand("%");
	print(file_name);
	local buffers = vim.api.nvim_list_bufs();
	local found_terminal = false;	
	local terminal_buf;
	for i, buf in ipairs(buffers) do
		local buftype = vim.api.nvim_buf_get_option(buf, "buftype");
		if buftype == "terminal" then
			found_terminal = true;
			terminal_buf = buf;
		end
	end
	if found_terminal then
		vim.api.nvim_buf_delete(terminal_buf, { force = true });
		functions.open_terminal();
	else
		functions.open_terminal();
	end
	vim.api.nvim_input("gc " .. file_name .. "<CR><CR>" .. "r<CR><CR>") ;
	return;
end

functions.compile_cpp = function()
	local file_name = vim.fn.expand("%");
	functions.open_terminal();
	vim.api.nvim_input("g++ " .. file_name .. " `pkg-config --cflags --libs opencv4` -g<cr>");
	vim.api.nvim_input("gdb " .. "./a.out<CR><CR><CR>r<CR>");
	-- vim.defer_fn(function ()
	-- 	vim.api.nvim_input("./a.out<CR>");
	-- end, 2000);
end;

-- run 
functions.run_shell = function()
	local file_name = vim.fn.expand("%");
	vim.fn.system({"chmod", "+x", file_name});
	functions.open_terminal();
	local run = "./"  .. file_name .. "<CR>";
	-- This function will be executed after 1 second (1000ms)
	vim.defer_fn(function()
		vim.api.nvim_input(run);
	end, 300)

end

functions.run_rust = function ()
	local file_name = vim.fn.expand("%");
	functions.open_terminal();
	local run = "cargo run<CR>";
	-- This function will be executed after 1 second (1000ms)
	vim.defer_fn(function()
		vim.api.nvim_input(run);
	end, 300)
end

functions.run_sql = function ()
	local filename = vim.fn.expand("%")
	functions.open_terminal();
	local run = "mysql -B  <LT> " .. filename .. " | column -t<CR>";
	vim.defer_fn(function()
		vim.api.nvim_input(run);
	end, 300)
end

functions.run_java = function ()
	local file_name = vim.fn.expand("%");
	functions.open_terminal();
	local name_without_extension = string.match(file_name, "^(.-)%.%w+$");

	vim.defer_fn(function()
		vim.api.nvim_input("javac " .. file_name  .. "<CR>");
	end, 300)
	vim.defer_fn(function()
		vim.api.nvim_input("java " .. name_without_extension  .. "<CR>");
	end, 600)
	vim.defer_fn(function ()
		print("name name_without_extension: " .. name_without_extension .. ".class");
		print("current path: " .. vim.fn.getcwd())
		for _, file in ipairs(vim.fn.glob("*.class", false, true)) do
			filepath = vim.fn.getcwd() .. "/" .. file
			print("filepath of class: " .. filepath)
			vim.fn.delete(filepath)
		end
	end, 2000)
end

functions.run_nodejs = function ()
	local file_name = vim.fn.expand("%");
	functions.open_terminal();
	local run = "node "  .. file_name .. "<CR>";
	-- This function will be executed after 1 second (1000ms)
	vim.defer_fn(function()
		vim.api.nvim_input(run);
	end, 300)
end

functions.run_default = function ()
	local found_run = functions.find_file_up_down_with_depth(vim.fn.getcwd(), 5, "run");
	if found_run then
		print("Found run file: " .. found_run);
		functions.open_terminal();
		vim.api.nvim_input("cd " .. vim.fn.fnamemodify(found_run, ":h") .. "<CR>");
		vim.api.nvim_input("bash run<CR>");
		return true
	else
		print("No run file found in current directory or parent directories.");
		return false
	end
end

functions.run = function ()
	local filename = vim.fn.expand("%");
	local file_extension = vim.fn.fnamemodify(filename, ":e");
	if (functions.run_default()) then
		return 0;
	end
	if file_extension == "py" then
		functions.run_py();
	elseif file_extension == "java" then
		functions.run_java();
	elseif file_extension == "c" then
		functions.run_c();
	elseif file_extension == "sh" or file_extension == "" then
		functions.run_shell();
	elseif file_extension == "cpp" then
		functions.compile_cpp();
	elseif file_extension == "js" then
		functions.run_nodejs();
	elseif file_extension == "sql" then
		functions.run_sql();
	elseif file_extension == "rs" then
		functions.run_rust();
	end
end

functions.run_py = function()
	local file_name = vim.fn.expand("%");
	print(file_name);
	local buffers = vim.api.nvim_list_bufs();
	local found_terminal = false;
	local terminal_buf;
	for i, buf in ipairs(buffers) do
		local buftype = vim.api.nvim_buf_get_option(buf, "buftype");
		if buftype == "terminal" then
			found_terminal = true;
			terminal_buf = buf;
		end
	end
	if found_terminal then
		vim.api.nvim_buf_delete(terminal_buf, { force = true });
		functions.open_terminal();
	else
		functions.open_terminal();
	end
	-- vim.api.nvim_input(". .run<CR>");

	local uv = vim.loop
	local current_path = uv.cwd();
	local max_depth = 8

	local venv_path = ""
	for _ = 1, max_depth do
		venv_path = current_path .. "/venv"
		venv_path1 = current_path .. "/.venv"
		local stat = uv.fs_stat(venv_path)
		local stat1 = uv.fs_stat(venv_path1)
		if stat or stat1 then
			if stat then
				venv_path = venv_path;
			else
				venv_path = venv_path1;
			end
			break;
		end
		local parent_path = current_path:match("(.+)/[^/]+$")
		if not parent_path then break end
		current_path = parent_path
	end
	print(venv_path)

	venv_path = venv_path .. "/bin/activate"
	vim.api.nvim_input(". " .. venv_path .. "<CR>");
	-- vim.api.nvim_input(". .run" .. "<CR>");
	-- vim.api.nvim_input(". ./")
	vim.api.nvim_input("python3 " .. file_name .. "<CR>");
	return 0;
end

functions.run_c = function()
	local file_type = check_file_format();
	print(file_type);
	if file_type == "c" then
		functions.compile_c();
	end
	if file_type == "cpp" then
		print("hello, cpp");
		functions.compile_cpp();
	end
end

functions.open_ssh = function()
	local home = os.getenv("HOME")
	local ssh_dir = os.getenv("SSH_DIR")
	local cwd = io.popen("pwd"):read("*l")  -- get current directory

	if cwd:match(home .. "/" .. ssh_dir) then
		return 1
	else 
		return 0
	end
end

-- terminal
local open_terminal = function()
	local buffers = vim.api.nvim_list_bufs();
	local found_terminal = false;	
	local terminal_buf;
	for i, buf in ipairs(buffers) do
		local buftype = vim.api.nvim_buf_get_option(buf, "buftype");
		if buftype == "terminal" then
			found_terminal = true;
			terminal_buf = buf;
		end
	end
	if found_terminal then
		vim.api.nvim_buf_delete(terminal_buf, {force = true});
	end
	vim.cmd("botright new");
	vim.opt.number = false;
	vim.opt.relativenumber = false;
	vim.cmd("edit term://bash");
	vim.cmd("resize 10");
	vim.opt.winfixheight = true;
	vim.api.nvim_input('i');

	if functions.open_ssh() == 1 then
		-- remove $HOME
		local home = os.getenv("HOME")
		local ssh_dir = os.getenv("SSH_DIR")
		local cwd = vim.fn.getcwd()

		-- get parent directory
		local parent_dir = cwd

		-- remove $HOME prefix
		if parent_dir:sub(1, #home) == home then
			parent_dir = parent_dir:sub(#home + 2)  -- +2 to remove "/"
		end

		-- remove $SSH_DIR prefix if present
		if parent_dir:sub(1, #ssh_dir) == ssh_dir then
			parent_dir = parent_dir:sub(#ssh_dir + 2)  -- +2 to remove "/"
		end

		print(parent_dir)

		vim.api.nvim_input("bash sshcd.sh<CR>");

		vim.api.nvim_input("cd " .. parent_dir .. "<CR>");
	end
end

-- === bash ===
functions.open_bash_config = function()
	local file_path = vim.g.bash_config;
	vim.cmd("e " .. file_path);
end

functions.open_terminal = open_terminal;

-- utils function to check if inside matrix environment
functions.in_matrix = function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

	-- search backwards to find the last \begin
	for i = row, 1, -1 do
		local line = lines[i]
		if line:match("\\begin{pmatrix}") or line:match("\\begin{bmatrix}") or line:match("\\begin{matrix}") then
			return true
		elseif line:match("\\end{") then
			return false
		end
	end
	return false
end

-- Navigating specific directory

functions.get_latest_download = function ()
	local files = vim.fn.globpath(vim.fn.expand("~/Downloads"), "*", false, true)
	if #files == 0 then return nil end

	table.sort(files, function(a, b)
		return vim.fn.getftime(a) > vim.fn.getftime(b)
	end)

	return files[1]
end


functions.find_doc_dir_up = function (start_dir, max_depth)
	local function is_doc_dir(path)
		local uv = vim.loop
		local stat = uv.fs_stat(path)
		return stat and stat.type == "directory"
	end

	local dir = start_dir
	for _ = 1, max_depth do
		local doc_path = dir .. "/doc"
		if is_doc_dir(doc_path) then
			return doc_path
		end
		-- Move one level up
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return nil
end

functions.find_dir_up_down_with_depth = function(start_dir, max_depth, target_dir)
	local function is_target_dir(path)
		local uv = vim.loop
		local stat = uv.fs_stat(path)
		return stat and stat.type == "directory" and vim.fn.fnamemodify(path, ":t") == target_dir
	end

	local dir = start_dir
	for _ = 1, max_depth do
		if is_target_dir(dir) then
			print("Found " .. target_dir .. " in current directory: " .. dir)
			return dir
		end
		-- Move one level up
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	-- Search Parent
	local parent_dir = vim.fn.fnamemodify(start_dir, ":h")
	for _ = 1, max_depth do
		if is_target_dir(parent_dir) then
			print ("Found " .. target_dir .. " in parent directory: " .. parent_dir)
			return parent_dir
		end
		-- Move one level up
		parent_dir = vim.fn.fnamemodify(parent_dir, ":h")
	end
	return nil
end

functions.find_file_up_down_with_depth = function(start_dir, max_depth, target_file)
	local function is_target_file(path)
		local uv = vim.loop
		local stat = uv.fs_stat(path)
		return stat and stat.type == "file" and vim.fn.fnamemodify(path, ":t") == target_file
	end

	local dir = start_dir
	for _ = 1, max_depth do
		if is_target_file(dir .. "/" .. target_file) then
			print("Found " .. target_file .. " in current directory: " .. dir)
			return dir .. "/" .. target_file
		end
		-- Move one level up
		dir = vim.fn.fnamemodify(dir, ":h")
	end

	-- Search Parent
	local parent_dir = vim.fn.fnamemodify(start_dir, ":h")
	for _ = 1, max_depth do
		if is_target_file(parent_dir .. "/" .. target_file) then
			print("Found " .. target_file .. " in parent directory: " .. parent_dir)
			return parent_dir .. "/" .. target_file
		end
		-- Move one level up
		parent_dir = vim.fn.fnamemodify(parent_dir, ":h")
	end
	print("No " .. target_file .. " found up to " .. max_depth .. " levels.")
	-- If not found, return nil
	return nil
end

functions.move_new_file_to_doc = function ()
	local cwd = vim.fn.getcwd()
	local doc_dir = functions.find_doc_dir_up(cwd, 5)
	if not doc_dir then
		print("No doc directory found up to 3 levels.")
		return
	end

	local latest_file = functions.get_latest_download()
	if not latest_file then
		print("No files found in Downloads.")
		return
	end

	local target = doc_dir .. "/" .. vim.fn.fnamemodify(latest_file, ":t")
	local ok, err = os.rename(latest_file, target)
	if ok then
		print("Moved " .. latest_file .. " to " .. target)

		vim.fn.jobstart({ "xdg-open", target }, {
			detach = true,
			on_exit = function() print("Opened: " .. target) end
		})

	else
		print("Failed to move file: " .. err)
	end
end

functions.time_tracker_start = function()
	vim.g.time_tracker = os.time()
	require("noice").notify("Time tracker started at: " .. os.date("%H:%M:%S", vim.g.time_tracker), {
		title = "Time Tracker",
		level = "info",
		timeout = 5000,
	})
end

functions.time_tracker_stop = function()
	if not vim.g.time_tracker then
		print("Time tracker is not running.")
		return
	end

	local elapsed = os.time() - vim.g.time_tracker
	local hours = math.floor(elapsed / 3600)
	local minutes = math.floor((elapsed % 3600) / 60)
	local seconds = elapsed % 60

	local output = string.format("%02d:%02d:%02d", hours, minutes, seconds)

	require("noice").notify("Time tracker stopped. Elapsed time: " .. output, {
		title = "Time Tracker",
		level = "info",
		timeout = 5000,
	})
	vim.fn.setreg('"', output)
	vim.fn.setreg('+', output)
	print(output)
	vim.g.time_tracker = nil

	vim.g.time_tracker = nil

end

functions.replace_old_window_terminal_with_new_terminal = function()
	-- Iterate over all windows
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")

		-- Check if buffer is a terminal
		if buf_type == "terminal" then
			-- Close the old terminal window
			vim.api.nvim_win_close(win, true)

			-- Open a new split with a terminal
			vim.cmd("botright new")
			vim.opt.number = false;
			vim.opt.relativenumber = false;
			vim.cmd("edit term://bash");
			vim.cmd("resize 10");
			vim.opt.winfixheight = true;
			vim.api.nvim_input('i');

			return -- Exit after replacing first terminal found
		end
	end

	-- If no terminal window found, just open a new terminal split
	vim.cmd("botright new")
	vim.opt.number = false;
	vim.opt.relativenumber = false;
	vim.cmd("edit term://bash");
	vim.cmd("resize 10");
	vim.opt.winfixheight = true;
	vim.api.nvim_input('i');

end

functions.cycle_hidden_terminal_to_window = function()
	local term_bufs = {}
	local visible_bufs = {}

	-- Get all windows and their buffers (visible buffers)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		visible_bufs[buf] = true
	end

	-- Find all loaded terminal buffers
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			if buftype == "terminal" and not visible_bufs[buf] then
				table.insert(term_bufs, buf) -- hidden terminal buffer
			end
		end
	end

	if #term_bufs == 0 then
		-- No hidden terminal buffer: open a new terminal split
		vim.cmd("split")
		vim.cmd("terminal")
	else
		-- Cycle to the first hidden terminal buffer
		local buf_to_show = term_bufs[1]
		vim.api.nvim_win_set_buf(0, buf_to_show) -- show terminal buffer in new window
	end
end

functions.open_current_existing_terminal = function()
	local found_terminal = false
	local terminal_buf
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			if buftype == "terminal" then
				found_terminal = true
				terminal_buf = buf
				break
			end
		end
	end

	if found_terminal then
		-- Open a new split with the existing terminal
		vim.cmd("botright split")
		vim.opt.number = false
		vim.opt.relativenumber = false
		vim.cmd("resize 10")
		vim.opt.winfixheight = true

		-- set to the first terminal buffer found
		vim.api.nvim_win_set_buf(0, terminal_buf)
		vim.api.nvim_input('i')
	else
		functions.open_terminal()
	end
end

functions.md_conv_pptx_open = function()
	local file_name = vim.fn.expand("%:t:r");
	print("hello" .. file_name);
	local command = "openpptx.sh " .. file_name ..".md" .. " 2> ~/Downloads/log"
	vim.fn.system(command);
end

vim.keymap.set({"n"}, "<leader>aa", functions.open_current_existing_terminal, { desc = "Open current existing terminal or new terminal" })
vim.g.open_terminal = open_terminal;
vim.g.move_workspace = functions.move_workspace;
return functions;
