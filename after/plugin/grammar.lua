local util = require('theprimeagen.utils');


local stat = util.safe_require("grammar-guard");

if not stat then
	return nil;
end
-- hook to nvim-lspconfig
require("grammar-guard").init()

