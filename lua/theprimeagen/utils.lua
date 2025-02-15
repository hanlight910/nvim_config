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
return M;
