-- plugins
local util = require('theprimeagen.utils');

local notify = util.safe_require("notify");

if not notify then
	return nil;
end

local plugin = "This is sample plugin";
vim.notify = require("notify");

vim.notify.setup({
	background_colour = "#300000", fps = 30,
	icons = {
		DEBUG = " ",
		ERROR = " ",
		INFO = " ",
		TRACE = "✎",
		WARN = " "
	},
	level = 2,
	minimum_width = 10,
	max_width = 100,
	render = "default",
	stages = "fade_in_slide_out",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	timeout = 2000,
	top_down = true,
})

local text = "# Welcome to Neovim!!";

vim.notify(text, "info", {
  title = "My Awesome Plugin",
  on_open = function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  end,
})

vim.keymap.set("n", "<C-h>", "<cmd>Telescope notify<CR>");

