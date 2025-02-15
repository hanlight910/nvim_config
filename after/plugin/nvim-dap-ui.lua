local util = require('theprimeagen.utils');

local stat = util.safe_require("dap");

if not stat then
	return nil;
end
local util1 = require('theprimeagen.utils');

local stat2 = util1.safe_require("dapui");

if not stat2 then
	return nil;
end

local dap =  require("dap");
local dapui = require("dapui");

dapui.setup();

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
