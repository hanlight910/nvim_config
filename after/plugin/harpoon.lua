--https://github.com/ThePrimeagen/harpoon

local mark = require("harpoon.mark");
local ui = require("harpoon.ui");
local term = require("harpoon.term");

local lua_config_path = "$HOME/.config/nvim"
-- local algorithm_path = "$HOME/archive/ 

mark.add_file(lua_config_path);

vim.keymap.set("n", "<leader>a", mark.add_file);
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu);

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end) vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)


vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
