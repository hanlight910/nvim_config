-- colors schemes link: https://dotfyle.com/neovim/colorscheme/trending
local util = require('theprimeagen.utils');

local stat = util.safe_require("tokyonight");

if not stat then
	return nil;
end

--
-- https://github.com/folke/tokyonight.nvim?tab=readme-ov-file
vim.cmd("colorscheme lunaperche")
vim.cmd("colorscheme tokyonight-day");
vim.cmd("colorscheme tokyonight-moon");
vim.cmd("colorscheme tokyonight-night");
vim.cmd("colorscheme tokyonight-storm");

print("custom highlights applied");
vim.opt.fillchars:append({ vert = "│" })
vim.opt.fillchars:append({ horiz = "o" })

-- For Neovim 0.9+ (recommended)
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff", bg = "NONE", bold = true })

-- For compatibility with older versions
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#ffffff", bg = "NONE", bold = true })

