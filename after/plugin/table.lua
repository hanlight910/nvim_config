-- https://github.com/SCJangra/table-nvim
vim.g.table_mode_disable_mappings = 1

vim.g.table_mode_always_active = 1
-- Set the table corner character globally
vim.g.table_mode_corner = '+'

vim.keymap.set({ 'n' }, '<A-t>', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "document symbols", silent = true })

