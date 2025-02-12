local opts = { noremap = true, silent = true }

local icon = require("icon-picker");
icon.setup({
    disable_legacy_commands = true,
})

vim.keymap.set("n", "<Leader>ii", "<cmd>IconPickerNormal<cr>", opts)
vim.keymap.set("n", "<Leader>iy", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
vim.keymap.set("i", "<A-e>", "<cmd>IconPickerInsert<cr>");
