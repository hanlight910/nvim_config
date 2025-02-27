require("lspsaga").setup({
  -- symbol_in_winbar = false,  -- Disable symbol in the winbar if needed
  -- use_saga_diagnostic_sign = true,
  -- hover = {
  --   max_width = 80,           -- Optional: Set the maximum width of the hover window
  --   max_height = 20,          -- Optional: Set the maximum height of the hover window
  --   border = 'rounded',       -- Optional: Set border style for the hover window
  --   scroll_off = 5            -- Optional: Scroll offset when hovering
  -- }
})

vim.keymap.set({'n'}, "<leader>lt", "<cmd>Lspsaga outline<CR>", {desc = "Luasaga outline"});
