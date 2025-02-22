-- local original_require = require; _G.require = function(module)
-- 	local status, result = pcall(original_require, module)
-- 	if not status then
-- 		vim.notify("Error loading module: " .. module, vim.log.levels.ERROR)
-- 		return nil
-- 	end
-- 	return result
-- end

require("theprimeagen.init");
