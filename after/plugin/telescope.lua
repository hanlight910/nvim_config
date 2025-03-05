local util = require('theprimeagen.utils'); local stat = util.safe_require("telescope");

if not stat then
	return nil;
end

local ts = require("telescope")
local tb = require('telescope.builtin')
local fb_actions = require('telescope').extensions.file_browser.actions

local function open_file_browser(directory, depth)
  telescope.extensions.file_browser.file_browser({
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


vim.api.nvim_set_keymap('n', '<leader>df', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-o>', '<cmd>Telescope oldfiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-g>', '<cmd>Telescope git_commits<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<A-t>', '<cmd>Telescope treesitter<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>pf', '<cmd>Telescope file_browser <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-s>', '<cmd>Telescope file_browser path=' .. vim.g.nvim_config ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-q>', '<cmd>Telescope file_browser path=' .. vim.g.bash_config ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-f>', '<cmd>Telescope file_browser path=' .. vim.g.fleeting ..  ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pap', '<cmd>Telescope file_browser path=' .. vim.g.projects ..  ' select_buffer=true depth=1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>te', '<cmd>lua open_file_browser(vim.g.project_1, 1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>Telescope file_browser path=' .. vim.g.project_1 .. ' select_buffer=true depth=10<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>Telescope noice<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<leader>td', '<cmd>Telescope lsp_definitions<CR>', { desc = "lsp_definitions", silent = true })
vim.keymap.set({ 'n' }, '<A-t>', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "document symbols", silent = true })
vim.keymap.set({ 'n' }, '<leader>tw', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', { desc = "dyanmic workspace symbols", silent = true })

vim.keymap.set({ 'n' }, '<leader>tl', '<cmd>Telescope live_grep<CR>', { desc = "telescope live grep", silent = true })

ts.setup({
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
					-- ["<CR>"] =open_or_expand_dir,
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
