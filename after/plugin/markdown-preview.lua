-- vim.keymap.set('n', '<leader>mp', '<Cmd>MarkdownPreview<CR>')
-- vim.keymap.set('n', '<leader>ms', '<Cmd>MarkdownPreviewStop<CR>')
-- vim.keymap.set('n', '<leader>mt', '<Cmd>MarkdownPreviewToggle<CR>')

vim.keymap.set('n', '<A-p>', '<Cmd>MarkdownPreview<CR>')
vim.keymap.set('n', '<leader>ms', '<Cmd>MarkdownPreviewStop<CR>')
vim.keymap.set('n', '<leader>mt', '<Cmd>MarkdownPreviewToggle<CR>')

vim.g.mkdp_preview_options = {
  mkit = {},
  katex = {},
  uml = {},
  maid = {},
  disable_sync_scroll = 1,  -- set to 1 to disable scroll sync
  sync_scroll_type = 'middle',
  hide_yaml_meta = 1,
  sequence_diagrams = {},
  flowchart_diagrams = {},
  content_editable = false,
  disable_filename = 0,
  toc = {}
}

