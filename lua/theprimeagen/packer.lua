local status, packer = pcall(require, "packer");

if status then
	return packer.startup(function(use)
		use 'wbthomason/packer.nvim'
		use({
			"olimorris/codecompanion.nvim",
			config = function()
				require("codecompanion").setup()
			end,
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			}
		})
		use 'nvim-tree/nvim-web-devicons'
		use "norcalli/nvim-colorizer.lua"
		use { "folke/snacks.nvim",
			opt = true,  -- Make snacks.nvim optional
			config = function()
				-- Inside the config, set up the plugin with your options
				require("snacks").setup({
					bigfile = { enabled = true },
					explorer = { enabled = true },
					indent = { enabled = true },
					input = { enabled = true },
					picker = { enabled = true },
					notifier = { enabled = true },
					quickfile = { enabled = true },
					scope = { enabled = true },
					-- scroll = { enabled = true },
					statuscolumn = { enabled = true },
					words = { enabled = true },
					image = {}
				})
			end,

		}

		use {
			'nvim-telescope/telescope.nvim', tag = '0.1.6',
			-- or                            , branch = '0.1.x',
			requires = { {'nvim-lua/plenary.nvim'} }
		}
		use { "nvim-telescope/telescope-file-browser.nvim",
			requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}
		}
		use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
		use { "xiyaowong/telescope-emoji.nvim" }

		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
		use { 'mbbill/undotree' }
		use { 'tpope/vim-fugitive' }
		use { 'folke/neodev.nvim' }
		use { 'nvimdev/lspsaga.nvim'}
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

		use({
			"iamcco/markdown-preview.nvim",
			run = "cd app && npm install",
			setup = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
		})

		use { 'numToStr/Comment.nvim' }
		use { "cohama/lexima.vim" }
		use { 'nvim-lualine/lualine.nvim' }
		use { "stevearc/dressing.nvim" }
		use { "ray-x/lsp_signature.nvim" }
		use { "onsails/lspkind.nvim" }
		use{ 'hrsh7th/cmp-nvim-lsp' }
		use{ 'hrsh7th/cmp-buffer' }
		use{ 'hrsh7th/cmp-path' }
		use{ 'hrsh7th/cmp-cmdline' }
		use{ 'hrsh7th/cmp-git' }
		use{ 'hrsh7th/nvim-cmp'   }
		use 'saadparwaiz1/cmp_luasnip'-- Snippet completion source
		use({
			"epwalsh/obsidian.nvim",
			tag = "*",  -- recommended, use latest release instead of latest commit
			requires = {
				"nvim-lua/plenary.nvim",
			},
		})
		use{ 'neovim/nvim-lspconfig' }
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
		}
		use {"robitx/gp.nvim"}
		use {
			"folke/which-key.nvim",
			optsl = function()
				return {
					triggers = {
						{ "<leader>", mode = "n" }
					}
				}
			end

		}
		use {"marcussimonsen/let-it-snow.nvim"}
		use { "kiyoon/jupynium.nvim", run = "run = . ~/projects/python-venv/venv/bin/activate", }

		-- use { "nvim-java/nvim-java" }
		-- use { "nvim-java/nvim-java" }
		use {
			"epwalsh/pomo.nvim",
			tag = "*",
			requires = {
				"rcarriga/nvim-notify",
			},
		}
		use { "xiyaowong/transparent.nvim" }
	end)

else
	print("Packer is not installed");
end
