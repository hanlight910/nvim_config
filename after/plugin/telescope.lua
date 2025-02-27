local util = require('theprimeagen.utils'); local stat = util.safe_require("telescope");

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
    {'n', '<leader>paa', function() find_files_with_cwd(vim.g.areas, "< 02-AREAS >") end},
}

for _, map in ipairs(keymaps) do
    vim.keymap.set(map[1], map[2], map[3])
end
vim.api.nvim_set_keymap('n', '<leader>df', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-o>', '<cmd>Telescope oldfiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-g>', '<cmd>Telescope git_commits<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-t>', '<cmd>Telescope treesitter<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>pf', '<cmd>Telescope file_browser <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-s>', '<cmd>Telescope file_browser path=' .. vim.g.nvim_config ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-q>', '<cmd>Telescope file_browser path=' .. vim.g.bash_config ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>Telescope file_browser path=' .. vim.g.ssu_path .. ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-f>', '<cmd>Telescope file_browser path=' .. vim.g.fleeting ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pap', '<cmd>Telescope file_browser path=' .. vim.g.projects ..  ' select_buffer=true depth=1<CR>', { noremap = true, silent = true })

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
			autodepth = true,
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

vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>Telescope noice<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>ld', '<cmd>Telescope lsp_definitions<CR>', { desc = "lsp lsp_definitions", silent = true })
vim.keymap.set({ 'n' }, '<leader>ls', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "lsp lsp_definitions", silent = true })
vim.keymap.set({ 'n' }, '<leader>lw', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', { desc = "lsp lsp_definitions", silent = true })

vim.keymap.set({ 'n' }, '<leader>gg', '<cmd>Telescope live_grep<CR>', { desc = "lsp_definitions", silent = true })
require("telescope").load_extension("emoji");
require('telescope').load_extension('fzf');
