-- https://github.com/lukas-reineke/indent-blankline.nvim/blob/master/doc/indent_blankline.txt local ibl = require("ibl");
-- highlights
local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}
-- customizing hooks
local hooks = require("ibl.hooks");
local ibl = require("ibl");

hooks.register(hooks.type.HIGHLIGHT_SETUP, function ()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight };

ibl.setup({
	scope = {
		highlight = highlight,
		show_start = false,
	},
	exclude = {
		buftypes = {
			'terminal',
			'nofile',
		},
		filetypes = {
			"dashboard"
		},
	},
	indent = {
		smart_indent_cap = false;
		char = "┊",
		priority  = 2,
	},
	whitespace = {
		highlight = {
			"Whitespace",
		},
		remove_blankline_trail = false,
	},

});
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark);

