-- https://github.com/VonHeikemen/lsp-zero.nvim

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
