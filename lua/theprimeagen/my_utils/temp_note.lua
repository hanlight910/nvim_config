local M = {};

M.temp_note = function()
	local buf_name = "temp"
	local buf_exists = false
	local buf_nr

	-- Check if buffer named 'temp' already exists
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(b):match(buf_name) then
			buf_exists = true
			buf_nr = b
			break
		end
	end

	-- If it exists, just open it in a vertical split
	if buf_exists then
		vim.cmd("rightbelow vsplit")
		vim.api.nvim_set_current_buf(buf_nr)
	else
		-- Create a new vertical split and buffer
		vim.cmd("vnew")
		buf_nr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(buf_nr, buf_name)
		vim.bo[buf_nr].buftype = "nofile"
		vim.bo[buf_nr].bufhidden = "wipe"
		vim.bo[buf_nr].swapfile = false
		vim.bo[buf_nr].filetype = "markdown"
		vim.bo[buf_nr].modifiable = true
	end

end

return M
