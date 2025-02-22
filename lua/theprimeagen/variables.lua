vim.g.root = os.getenv("HOME");
vim.g.archive = vim.g.root .. "/archive";
vim.g.areas = vim.g.archive .. "/02-AREAS";
vim.g.projects = vim.g.archive .. "/01-PROJECTS";
vim.g.fleeting = vim.g.archive .. "/05-FLEETING";
vim.g.config = vim.fn.stdpath("config");

vim.g.algorithm = vim.g.areas .. "/algorithm";
vim.g.baekjoon = vim.g.algorithm .. "/baekjoon";
vim.g.ssu_path = vim.g.areas .. "/ssu/1학년_2학기/courses";

--- bash path
vim.g.bash_config = vim.g.root .. "/.my_config";
