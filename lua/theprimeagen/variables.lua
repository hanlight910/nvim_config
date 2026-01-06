vim.g.root = os.getenv("HOME");
vim.g.nvim_config = vim.fn.stdpath("config");

vim.g.archive = vim.g.root .. "/archive";
vim.g.areas = vim.g.archive .. "/02-AREAS";
vim.g.fleeting = vim.g.archive .. "/05-FLEETING";
vim.g.TIL = vim.g.archive .. "/06-DAILY/TIL";

vim.g.vim_note = vim.g.archive .. "/05-FLEETING/vim/note.md";
vim.g.todo_list = vim.g.archive .. "/todo_list.md";

vim.g.algorithm = vim.g.areas .. "/algorithm";
vim.g.algorithm_notes = vim.g.TIL .. "/algorithm/baekjoon";
vim.g.baekjoon = vim.g.areas .. "/baekjoon"

--- bash path
vim.g.bash_config = vim.g.root .. "/.my_config";
vim.g.remote_config = vim.g.root .. "/remote_ssh" .. "/.my_config";

-- etc
vim.g.projects = vim.g.root .. "/projects";
vim.g.py_projects = os.getenv("PY_PROJECTS") or (vim.g.projects .. "/python");
vim.g.project_1 = os.getenv("PROJECT_1") or (vim.g.projects .. "/project1");
vim.g.time_track_path  = vim.g.archive .. "/03-RESOURCES/time-tracking.txt"

vim.g.current_tracking = {}

local current_time_tracking = {}

return current_time_tracking

