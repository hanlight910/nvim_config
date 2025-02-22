vim.opt.guicursor = ""
vim.g.mapleader = " "
vim.g.encoding = "utf-8"
vim.g.fileencode = "utf-8"
vim.g.termencoding = "utf-8"

vim.opt.nu = true;
vim.opt.relativenumber = true --현제 줄 기준 위 아래 줄 오름차순으로 자동 바뀜

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false;

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.autoread = true --vim 외부에서 파일이 변경될 경우 자동으로 다시 읽어드립니다.

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
vim.cmd [[
	augroup ChangeDirectory
	autocmd!
	autocmd BufEnter * silent! lcd %:p:h
	augroup END
]]
vim.opt.conceallevel = 2;
vim.cmd("syntax")

local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]
print("hardmode enabled");

vim.api.nvim_set_keymap('i', '<Up>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Down>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Left>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Right>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Del>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.keymap.set('i', '<Bs>', '<C-o>' .. msg)

-- Disable arrow keys in normal mode with a styled message
vim.api.nvim_set_keymap('n', '<Up>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Down>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Left>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Right>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<BS>', msg, { noremap = true, silent = false })


vim.o.cursorline  = true;
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",  -- Apply to all file types, or specify file types (e.g., "*.py")
    callback = function()
        -- Automatically reload the buffer without prompting the user
        vim.cmd("e!")
    end
})

