-- colors schemes link: https://dotfyle.com/neovim/colorscheme/trending
local util = require('theprimeagen.utils');

local stat = util.safe_require("tokyonight");

if not stat then
	return nil;
end

--
-- https://github.com/folke/tokyonight.nvim?tab=readme-ov-file
-- -- vim.cmd("colorscheme tokyonight-moon");
-- vim.cmd("colorscheme tokyonight-day");
-- vim.cmd("colorscheme tokyonight-storm");
vim.cmd("colorscheme tokyonight-night");

