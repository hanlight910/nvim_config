vim.g.root = os.getenv("HOME");
vim.g.archive = vim.g.root .. "/archive";
vim.g.areas = vim.g.archive .. "/02-AREAS";
vim.g.TIL = vim.g.archive .. "/06-DAILY/TIL";
vim.g.fleeting = vim.g.archive .. "/05-FLEETING";
vim.g.vim_note = vim.g.archive .. "/05-FLEETING/vim/note.md";
vim.g.todo_list = vim.g.archive .. "/05-FLEETING/todo_list.md";
vim.g.nvim_config = vim.fn.stdpath("config");

vim.g.algorithm = vim.g.areas .. "/algorithm";
vim.g.algorithm_notes = vim.g.TIL .. "/algorithm/baekjoon";
vim.g.baekjoon = vim.g.areas .. "/baekjoon"
-- vim.g.ssu_path = vim.g.areas .. "/ssu";
vim.g.project_1 = os.getenv("PROJECT_1");

--- bash path
vim.g.bash_config = vim.g.root .. "/.my_config";

vim.g.projects = vim.g.root .. "/projects";
