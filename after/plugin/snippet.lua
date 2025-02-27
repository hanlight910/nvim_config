local util = require('theprimeagen.utils');

local stat = util.safe_require("luasnip");

if not stat then
	return nil;
end

local ls = require("luasnip");
local s = ls.snippet;
local t = ls.text_node;
local i = ls.insert_node;
local d = ls.dynamic_node;
local sn = ls.snippet_node;
local c = ls.choice_node;
local rep = require("luasnip.extras").rep;


ls.config.set_config({
	history = true,
	updateevents = "TextChanged, TextChangedI",

	-- Auto snippets
	enable_autosnippets = true,
})

vim.keymap.set({"i"}, "<C-k>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

ls.add_snippets("python", {
	s("importdata", {
		t({"import numpy as np;", "import pandas as pd;", "import sklearn as sk;"});
	})
})
