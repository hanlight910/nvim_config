-- https://github.com/VonHeikemen/lsp-zero.nvim
local util = require('theprimeagen.utils');

local stat = util.safe_require("lsp-zero");

if not stat then
	return nil;
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({

})
require('mason-lspconfig').setup({
	ensure_installed = {
		'rust_analyzer',
		'clangd',
		'pyright',
		'lua_ls',
		'cssls',
		'emmet_language_server',
		'texlab',
		'ts_ls',
	},
	automatic_installation = true,
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	}
});

require("neodev").setup({
	library = {
		plugins = false,
	}
})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
	require'lspconfig'.lua_ls.setup {
		settings = {
			Lua = {
				runtime = {
					version = "Lua 5.1"
				}
			}
		}
		-- on_init = function(client)
		-- 	if client.workspace_folders then
		-- 		local path = client.workspace_folders[1].name
		-- 		if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc')) then
		-- 			return
		-- 		end
		-- 	end
		--
		-- 	client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
		-- 		runtime = {
		-- 			-- Tell the language server which version of Lua you're using
		-- 			-- (most likely LuaJIT in the case of Neovim)
		-- 			version = 'LuaJIT'
		-- 		},
		-- 		-- Make the server aware of Neovim runtime files
		-- 		workspace = {
		-- 			checkThirdParty = false,
		-- 			library = {
		-- 				vim.env.VIMRUNTIME
		-- 				-- Depending on the usage, you might want to add additional paths here.
		-- 				-- "${3rd}/luv/library"
		-- 				-- "${3rd}/busted/library",
		-- 			}
		-- 			-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
		-- 			-- library = vim.api.nvim_get_runtime_file("", true)
		-- 		}
		-- 	})
		-- end,
		-- settings = {
		-- 	Lua = {}
		-- }
}
})

vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float(0, {scope=\"line\"})<CR>");

lspconfig.emmet_language_server.setup({
	filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
	-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
	-- **Note:** only the options listed in the table are supported.
	init_options = {
		---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})
--
lspconfig.pyright.setup {
	capabilities = capabilities,
	-- on_attach = function ()
	-- 	    client.resolved_capabilities.textDocument.completion.completionItem.snippetSupport = true
	-- end
}
-- vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
--   config = config or {}
--   config.focus_id = ctx.method
--   if not (result and result.contents) then
--     return
--   end
--   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
--   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
--   if vim.tbl_isempty(markdown_lines) then
--     return
--   end
--   return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
-- end
-- vim.lsp.handlers["textDocument/hover"] = function() end

-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	callback = function()
-- 		vim.lsp.buf_clear_references()  -- This prevents hover popups in insert mode
-- 	end
-- })
