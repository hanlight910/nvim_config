return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use { 'ThePrimeagen/harpoon' }
	use { 'mbbill/undotree' }
	use { 'tpope/vim-fugitive' }
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			{'neovim/nvim-lspconfig'},
			{'L3MON4D3/LuaSnip'},
		}
	}
	use { 'nvim-tree/nvim-tree.lua', }

	use {
		"epwalsh/pomo.nvim",
		tag = "*",
		requires = {
			"rcarriga/nvim-notify",
		},
	}
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- use { "vim-airline/vim-airline" }
	-- use { "vim-airline/vim-airline-themes" }
	use { "preservim/tagbar" }
	-- use { "Lokaltog/vim-powerline" }
	use { "cohama/lexima.vim" }
	use {
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		requires = {'nvim-tree/nvim-web-devicons'}
	}
	use { 'nvim-lualine/lualine.nvim' }
	-- use {
	-- 	'kdheepak/tabline.nvim' ,
	-- 	requires = {
	-- 		{ 'hoob3rt/lualine.nvim', opt = true },
	-- 		{'kyazdani42/nvim-web-devicons', opt = false},
	-- 	}
	-- }
	use { 'numToStr/Comment.nvim' }
	use { "mfussenegger/nvim-dap" }
	use { "mfussenegger/nvim-dap-python" }
	use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
	use { "stevearc/dressing.nvim" }
	use { "ziontee113/icon-picker.nvim"}
	use({
		"epwalsh/obsidian.nvim",
		tag = "*",  -- recommended, use latest release instead of latest commit
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use{ 'neovim/nvim-lspconfig' }
	use{ 'hrsh7th/cmp-nvim-lsp' }
	use{ 'hrsh7th/cmp-buffer' }
	use{ 'hrsh7th/cmp-path' }
	use{ 'hrsh7th/cmp-cmdline' }
	use{ 'hrsh7th/nvim-cmp'   }
	use { 'BurntSushi/ripgrep' }
	use { 'jpmcb/nvim-llama' }
	use({
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!:).
		run = "make install_jsregexp"
	})
	use{ "lukas-reineke/indent-blankline.nvim" }

	use({
		'MeanderingProgrammer/render-markdown.nvim',
		after = { 'nvim-treesitter' },
		-- requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
		-- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
		config = function()
			require('render-markdown').setup({})
		end,
	})
	use{"folke/tokyonight.nvim"}
	use {"folke/noice.nvim"}
	use {"MunifTanjim/nui.nvim"}
	use {
    'nvim-flutter/flutter-tools.nvim',
    requires = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
	use {"robitx/gp.nvim"},
}
end)
