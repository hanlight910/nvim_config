local util = require('theprimeagen.utils');

local stat = util.safe_require("cmp");

if not stat then
	return nil;
end

local cmp = require'cmp'
local compare = cmp.config.compare;

cmp.setup({
	preselect = cmp.PreselectMode.Item,
	completion = {
		autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }, -- Trigger on text change
		completeopt = 'menu,menuone,noinsert,noselect',  -- Control popup behavior
	},
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	view = {
		entries = {
			name = "custom",
			selection_order = "near_cursor",
			follow_cursor = true,
		}
	},
	window = {
		completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
		documentation = {
			border = "rounded",
			winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
			max_width = 80,
			max_height = 20,
		},
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				select = true,
				behavior = cmp.ConfirmBehavior.Insert,
			}),
			{ "i", "c" }
		),
		['<C-e>'] = cmp.mapping.abort(),
		["<C-n>"] = cmp.mapping.select_next_item({
			behavior = cmp.ConfirmBehavior.Insert,
		}),
		["<C-p>"] = cmp.mapping.select_prev_item({
			behavior = cmp.ConfirmBehavior.Insert,
		}),
	}),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }, -- For luasnip users.
		{ name = "jupynium" },
		{ name = 'buffer' },
	}),
	-- formatting = {
	-- 	format = {
	--
	-- 	}
	-- },
	sorting = {
		priority_weight = 1.0,
		comparators = {
			compare.score,            -- Jupyter kernel completion shows prior to LSP
			compare.recently_used,
			compare.locality,
			-- ...
		},
	},
	formatting = {
		format = function(entry, vim_item)
			-- Add the source name to each entry label
			vim_item.menu = "[" .. entry.source.name .. "]"
			return vim_item
		end
	},
	experimental = {
		ghost_text = true,
	}

})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
 
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' },
	}, {
		{ name = 'buffer' },
	})
})
require("cmp_git").setup() 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
			{ name = 'cmdline' }
		}),
	matching = { disallow_symbol_nonprefix_matching = false }
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- replace <your_lsp_server> with each lsp server you've enabled.
-- require('lspconfig')["pyright"].setup {
-- 	capabilities = capabilities
-- }

local entry = cmp.get_selected_entry()
if entry then
  print("Selected entry: " .. entry:get_completion_item().label)
end
