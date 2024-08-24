local c = require("theprimeagen.templates.c");

function open_terminal ()
    vim.cmd("botright new");
    vim.opt.number = false;
    vim.opt.relativenumber = false;
    vim.cmd("terminal");
    vim.cmd("resize 10");
    vim.opt.winfixheight = true;
    vim.api.nvim_input('i');
end

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex);
vim.keymap.set("n", "<leader>ctm", c.insert_c_template);

vim.keymap.set("i", "jk", "<Esc>");
vim.keymap.set("i", "kj", "<Esc>");
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

vim.keymap.set("n", "<leader>tt", open_terminal);

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
vim.keymap.set("n", "<leader>nv", "<cmd>ex /home/light/archive/05-FLEETING/nvim_setting.md<CR>");
vim.keymap.set("n", "<A-s>", "<cmd>ex /home/light/.config/nvim/lua/theprimeagen/remap.lua<CR>");
vim.keymap.set("n", "<leader>bd", "<cmd>bd!<CR>");

vim.keymap.set("n", "<leader>al", "<cmd>ex /home/light/archive/06-DAILY/TIL/algorithm<CR>");

function create_md_file()
    local input = vim.fn.input("Enter filename: ");
    local dir = "/home/light/archive/05-FLEETING/"
    local file_path = dir .. input
    vim.cmd("e " .. file_path);
end

vim.keymap.set("n", "<leader>fl", ":lua create_md_file()<CR>", { noremap = true, silent = true })

move_next_buffer = function()
    local current_buffer = vim.api.nvim_get_current_buf();
    local buffers = vim.api.nvim_list_bufs();

    for _, buf in ipairs(buffers) do
        if buf > current_buffer and vim.api.nvim_buf_is_loaded(buf) then
            local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype');
            if buf_type ~= 'terminal' and buf_type ~= 'nofile' then
                vim.api.nvim_set_current_buf(buf);
                return;
            end
        end
    end

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
            if buf_type ~= 'terminal' and buf_type ~= 'nofile' then
                vim.api.nvim_set_current_buf(buf)
                return
            end
        end
    end
end

move_previous_buffer = function()
    local current_buffer = vim.api.nvim_get_current_buf();
    local buffers = vim.api.nvim_list_bufs();

    for i = #buffers, 1, -1 do
        buf = buffers[i];
        if vim.api.nvim_buf_is_loaded(buf) then
            local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype');
            if buf_type ~= 'terminal' and buf_type ~= 'nofile' then
                vim.api.nvim_set_current_buf(buf);
                return;
            end
        end
    end

    for i = #buffers, 1, -1 do
        buf = buffers[i];
        if vim.api.nvim_buf_is_loaded(buf) then
            local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype');
            if buf_type ~= 'terminal' and buf_type ~= 'nofile' then
                vim.api.nvim_set_current_buf(buf);
                return;
            end
        end
    end
end

vim.keymap.set("n", "<leader>bn", "<cmd>lua move_next_buffer()<cr>");
vim.keymap.set("n", "<leader>bp", "<cmd>lua move_previous_buffer()CR>");
