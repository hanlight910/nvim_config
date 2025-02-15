local util = require('theprimeagen.utils');

local stat = util.safe_require("silicon");

if not stat then
	return nil;
end


require('silicon').setup({
	font = "Ubuntu Mono",
})
