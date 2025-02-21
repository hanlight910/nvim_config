-- https://github.com/VonHeikemen/lsp-zero.nvim

local util = require('theprimeagen.utils');

local stat = util.safe_require("lsp-zero");

if not stat then
	return nil;
end

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
		"jdtls"
	},
	automatic_installation = true,
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
        end,
	}
});

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})
vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float(0, {scope=\"line\"})<CR>");
