require("flutter-tools").setup {
	-- Other configuration options...
	dev_log = {
		enabled = true,
		open_cmd = "belowright 10split",  -- Open the log buffer in a horizontal split below
		focus_on_open = true,             -- Optional: Focus on the log buffer when opened
		notify_errors = true,            -- Ensure notifications are according to needs
	},
	outline = {
		open_cmd = "belowright 10new"
	}
}

