local functions = {};

--- ==== assist ====
local function check_file_format()
	local file_type = vim.bo.filetype;
	print(file_type);

	return file_type;
end

--- ==== window navigation ====
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
	vim.api.nvim_input(". ../venv/bin/activate<CR>");
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

	if file_type == "python" then
		print("hello py");
		functions.run_py();
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

vim.g.open_terminal = open_terminal;
vim.g.move_workspace = functions.move_workspace;
return functions;

