vim.opt.guicursor = ""

vim.opt.nu = true;
vim.opt.relativenumber = true --현제 줄 기준 위 아래 줄 오름차순으로 자동 바뀜

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = 
    false;
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
