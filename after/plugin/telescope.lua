local util = require('theprimeagen.utils');

local stat = util.safe_require("telescope");

if not stat then
	return nil;
end

local ts = require("telescope")
local tb = require('telescope.builtin')

local function find_files_with_cwd(cwd, title)
    tb.find_files({
        prompt_title = title,
        cwd = cwd,
        hidden = true,
    })
end
local keymaps = {
    {'n', '<leader>pf', tb.find_files},
    {'n', '<leader>pb', tb.buffers},
    {'n', '<C-p>', tb.git_files},
    {'n', '<leader>ps', function()
        tb.grep_string({ search = vim.fn.input("Grep > ") })
    end},
    {'n', '<leader>pa', function() find_files_with_cwd(vim.g.archive, "< ARCHIVE >") end},
    {'n', '<leader>paa', function() find_files_with_cwd(vim.g.areas, "< 02-AREAS >") end},
    {'n', '<leader>pap', function() find_files_with_cwd(vim.g.projects, "< 03-PROJECTS >") end},
}

for _, map in ipairs(keymaps) do
    vim.keymap.set(map[1], map[2], map[3])
end
vim.api.nvim_set_keymap('n', '<leader>df', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-o>', '<cmd>Telescope oldfiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-g>', '<cmd>Telescope git_commits<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-t>', '<cmd>Telescope treesitter<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-f>', '<cmd>Telescope treesitter<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>pf', '<cmd>Telescope file_browser <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-s>', '<cmd>Telescope file_browser path=' .. vim.g.config ..  ' select_buffer=true<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-q>', '<cmd>Telescope file_browser path=' .. vim.g.bash_config ..  ' select_buffer=true<CR>', { noremap = true, silent = true })

local fb_picker = require("telescope").extensions.file_browser

local fb_pi = function(path)
	fb_picker.file_browser({
	  path = vim.g.config,
	  grouped = true,
	depth = 10,
	})
end

ts.setup({
	extensions = {
		file_browser = {
			theme = "ivy",
			hidden = true,
			depth = 10,
			autodepth = true,
		},
	},
});
ts.load_extension("file_browser");
