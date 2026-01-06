local M = {};

M.safe_require = function(module)
	local status, mod = pcall(require, module);
	if not status then
		vim.notify("Install " .. module, "error");
		return nil;
	else
		return mod;
	end
end

-- Check if external command exists in PATH
M.command_exists = function(cmd)
	local handle = io.popen("command -v " .. cmd .. " 2>/dev/null")
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result ~= ""
end

-- Safe command execution with existence check
M.safe_exec_command = function(cmd, error_msg)
	local cmd_name = cmd:match("^%S+")  -- Extract first word (command name)
	if not M.command_exists(cmd_name) then
		local msg = error_msg or ("Command not found: " .. cmd_name)
		vim.notify(msg, vim.log.levels.WARN)
		return false
	end
	return true
end

return M;
