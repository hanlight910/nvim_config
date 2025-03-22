-- guide https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#functionnode
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
local f = ls.function_node;
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

ls.add_snippets("all", {
	s("trig", {
		t({"Hello, first line", "Another line!!"}),
		t("is it Third line?"),
		t("nope it wasn't")
	}),
	s("ti", {
		t({"After expanding, the cursor is here ->"}), i(1),
		t({"","After jumping forward once, cursor is here ->"}), 

	}),

	s("bmat", {
		t({"$$\\begin{bmatrix}",""}),
		i(1),
		t({"","\\end{bmatrix}$$"})
	})
})

ls.add_snippets("python", {
	s("importdata", {
		t({"import numpy as np;", "import pandas as pd;", "import sklearn as sk;",
			"import matplotlib.pyplot as plt;"
		});
	}),
})

ls.add_snippets("markdown", {
	s("bmat", {
		t({"\\begin{bmatrix}",""}),
		i(1),
		t({"","\\end{bmatrix}"})
	}),
	s("fr", {
		t("\\frac"),t("{"), i(1), t("}"), t("{"), i(2), t("}")
	}),
	s("sum", {
		t("\\sum^n_{i=0}")
	}),
	s("$$", {
		t({"$$"}),i(1),t({"$$"})
	})
})

ls.add_snippets("all", {
	s("stl", {
		t("class "), i(1), t({" extends StatelessWidget {", "",}),
		f(function (args)
			return "	const " .. args[1][1] .. "({Key? key}): super(key: key);"
		end, {1}),
		t({"", "", "	Widget build(BuildContext context) {", ""}),
		t({"		return "}), i(2, "Scaffold()"), t({";", " "}),
		t({"	}", "}"}),
	}),
	s("stf", {
		t("class "), i(1, "MyWidget"), t({" extends StatefullWidget {", "",}),
		f(function (args)
			return "	" .. args[1][1] .. "({Key? key}): super(key: key);"
		end, {1}),
		t({"","", "	@override", ""}),
		f(function (args)
			return "	" .. "State<" ..
				args[1][1] .. "> " .. "createState() => " ..
				'_' .. args[1][1] .. "State();"
		end, {1}),
		t({"", "}" ,""}),
		f(function (args)
			return "class _" .. args[1][1] .. " extends " .. "State<" ..
				args[1][1] .. '> {'
		end, {1}),
		t({"", "", "	@override", "	Widget build(BuildContext context) {", ""}),
		t({"			return "}), i(2, "Scaffold()"), t({";", " "}), t({"	}", "}"}),
	})
})
