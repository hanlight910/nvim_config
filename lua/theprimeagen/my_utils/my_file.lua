local M = {}

M.is_subpath_of_current_file = function(subpath)
	if not subpath or type(subpath) ~= 'string' then
		return false, "Invalid subpath argument: must be a string"
	end

	local current_file_path = vim.api.nvim_buf_get_name(0) -- Get full path of current buffer

	if current_file_path == '' then
		return false, "Current buffer is not associated with a file path"
	end

	-- Use string.find to check if subpath is part of the current file's path
	-- string.find returns nil if not found, or the start and end indices if found
	if string.find(current_file_path, subpath, 1, true) then -- The `true` argument makes the search plain (no magic characters)
		return true
	else
		return false
	end
end

-- Example usage:
return M


