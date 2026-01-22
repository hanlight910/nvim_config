local util = require('theprimeagen.utils')
local stat = util.safe_require("persisted")

if not stat then
	return nil
end

-- Exclude keymaps and options from session to prevent conflicts
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize"

local persisted = require("persisted")

require("persisted").setup()

