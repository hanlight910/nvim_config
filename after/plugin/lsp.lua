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
        'tsserver',
        'eslint',
        'rust_analyzer',
        'clangd',
        'pyright',
        'lua_ls',
        'quick_lint_js'
    },
    automatic_installation = true,
    handlers = {
        function(server_name)
            require('lspconfig').pyright.setup({
				setting = {
					python = {
						pythonPath="/home/light/archive/01-PROJECTS/lms/venv/bin/python3";
					}
				}
			})
        end,
    },
});

