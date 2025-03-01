-- vim.opt.guicursor = 'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor' -- Blinking cursor
vim.g.mapleader = " "
vim.g.encoding = "utf-8"
vim.g.fileencode = "utf-8"
vim.g.termencoding = "utf-8"

vim.opt.nu = true;
vim.opt.relativenumber = true --현제 줄 기준 위 아래 줄 오름차순으로 자동 바뀜

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false;

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.autoread = true --vim 외부에서 파일이 변경될 경우 자동으로 다시 읽어드립니다.

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
vim.cmd [[
	augroup ChangeDirectory
	autocmd!
	autocmd BufEnter * silent! lcd %:p:h
	augroup END
]]
vim.opt.conceallevel = 2;
vim.cmd("syntax")

local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]
print("hardmode enabled");

vim.api.nvim_set_keymap('i', '<Up>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Down>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Left>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Right>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Del>', '<C-o>' .. msg, { noremap = true, silent = false })
vim.keymap.set('i', '<Bs>', '<C-o>' .. msg)

-- Disable arrow keys in normal mode with a styled message
vim.api.nvim_set_keymap('n', '<Up>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Down>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Left>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Right>', msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<BS>', msg, { noremap = true, silent = false })


vim.o.cursorline  = true;
-- vim.o.cursorword  = false;
vim.o.cursorcolumn = false;
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",  -- Apply to all file types, or specify file types (e.g., "*.py")
    callback = function()
        -- Automatically reload the buffer without prompting the user
        vim.cmd("e!")
    end
})

-- Set a custom background and foreground color for visual selections

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.api.nvim_set_hl(0, "Visual", { bg = "Grey", fg = "White" })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#242544", })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#89b4fa", bold = true })

		-- Customization for Pmenu
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#FFFFFF", fg = "#000000" })
		vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

		-- vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
		-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
		-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
		-- vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })
		--
		-- vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
		-- vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })

    end,
})


