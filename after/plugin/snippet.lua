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


vim.keymap.set({"i"}, "<A-k>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<A-n>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<A-p>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set("i", "<A-j>", "<Plug>luasnip-next-choice", {});


vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

ls.filetype_extend("markdown", {"c", "cpp"});
ls.filetype_extend("lua", {"c"});
ls.filetype_extend("cpp", {"c"});

ls.add_snippets("lua", {
	s("key", {
		c(1, {
			sn(nil, {
				t("vim.keymap.set(");
				t("{'i'}, \"");
				i(1);
				t("\", \"");
				i(2);
				t("\", {});")
			}),
			sn(nil, {
				t("vim.keymap.set(");
				t("{'n'}, \"");
				i(1);
				t("\", \"");
				i(2);
				t("\", {});")
			}),
		})
	})
})

ls.add_snippets("c", {
	s("std", {
		c(1, {
			sn(nil, {
				t("#include<stdio.h>"),
				t({"", "#include<stdint.h>"}),
				t({"", "", "int32_t main(void) {", "\t"}),
				i(1, ""),  -- First insertion point (placeholder 1) with a tab
				t({"", "\treturn 0;"}),
				t({"", "}"})
			}),
			sn(nil, {
				t("#include<stdio.h>"),
				-- Start of the main function declaration
				t({"", "", "int main(void) {", "\t"}),
				-- InsertNode for code inside the main function
				i(1, ""),  -- First insertion point (placeholder 1) with a tab
				-- Static text for return statement
				t({"", "\treturn 0;"}),
				-- Close the function
				t({"", "}"})
			}),

		})
	}),
	s("for", {
		c(1, {
			sn(nil, {
				t("for (int i = 0; i < "),
				i(1),
				t({"; i += 1) {", "\t"}),
				t("printf(\"%2d \", "),
				i(2),
				t(");"),
				t({"", "}"}),
			}),
			sn(nil, {
				t("for (int i = 0; i < "),
				i(1),
				t({"; i += 1) {", "\t"}),
				t("for (int j = 0; j < "),
				rep(1),
				t({"; j += 1) {", "\t\t"}),
				i(2),
				t({"", "\t}"}),
				t({"", "}"}),
			}),
			sn(nil, {
				t("for (int i = 0; i < "),
				i(1),
				t({"; i += 1) {", "\t"}),
				t("for (int j = 0; j < "),
				rep(1),
				t({"; j += 1) {", "\t\t"}),
				t("printf(\"%2d \", "),
				i(2),
				t(");"),
				t({"", "\t}"}),
				t({"", "\tprintf(\"\\n\");"});
				t({"", "}"}),
			})
		}),
	}),
	s({trig="ff", dscr="Expands 'ff' into '\frac{}{}'"},
	{
		t("\\frac{"),
		i(1),  -- insert node 1
		t("}{"),
		i(2),  -- insert node 2
		t("}")
	}
	),
})

