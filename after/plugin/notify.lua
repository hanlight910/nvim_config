-- plugins
local plugin = "This is sample plugin";
vim.notify = require("notify");

vim.notify.setup({
	background_colour = "#300000", fps = 30,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = ""
	},
	level = 2,
	minimum_width = 50,
	render = "default",
	stages = "fade_in_slide_out",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	timeout = 5000,
	top_down = true,
})

local text = "# something";

vim.notify(text, "info", {
  title = "My Awesome Plugin",
  on_open = function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  end,
})

