-- require("snacks").setup();
local utils = require("theprimeagen.utils")
local packer = utils.safe_require("packer")
if not packer then return end

packer.loader('snacks.nvim')
