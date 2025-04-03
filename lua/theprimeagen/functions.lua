local functions = {};

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
		for _, file in ipairs(vim.fn.glob("*.class", true, true)) do
			vim.fn.delete(file)
		end
	end, 900)
end

functions.run = function ()
	local filename = vim.fn.expand("%");
	local file_extension = vim.fn.fnamemodify(filename, ":e");
	print(file_extension);
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
	local max_depth = 3
	
	local venv_path = ""
	for _ = 1, max_depth do
		venv_path = current_path .. "/venv"
		local stat = uv.fs_stat(venv_path)
		if stat and stat.type == "directory" then
			break
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
end

-- === bash ===
functions.open_bash_config = function()
	local file_path = vim.g.bash_config;
	vim.cmd("e " .. file_path);
end

functions.open_terminal = open_terminal;

-- vim.keymap.set({"n", "i"}, "<leader>te", functions.run_java);
vim.g.open_terminal = open_terminal;
vim.g.move_workspace = functions.move_workspace;
return functions;
