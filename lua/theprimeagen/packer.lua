-- Auto-bootstrap Packer
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		vim.notify("Installing Packer...", vim.log.levels.INFO)
		fn.system({'git', 'clone', '--depth', '1',
		           'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		vim.notify("Packer installed! Please run :PackerSync", vim.log.levels.INFO)
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer");
local func = require("vim.func")

if status then
	return packer.startup(function(use)
		use { 
			"zbirenbaum/copilot.lua",
			-- cmd = "Copilot",
			-- event = "InsertEnter",
			-- config = function()
			-- 	require("copilot").setup({})
			-- end,
			opt = false
		}
		-- use "github/copilot.vim"
		use "hat0uma/csvview.nvim"
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
			'nvim-telescope/telescope.nvim', 
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
		use { 'kdheepak/tabline.nvim' }
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
		use{'bydlw98/cmp-env'}
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

		use {
			"epwalsh/pomo.nvim",
			tag = "*",
			requires = {
				"rcarriga/nvim-notify",
			},
		}
		use { "xiyaowong/transparent.nvim" }
		use {
			'nvim-java/nvim-java',
			requires = {
				'nvim-java/lua-async-await',
				'nvim-java/nvim-java-refactor',
				'nvim-java/nvim-java-core',
				'nvim-java/nvim-java-test',
				'nvim-java/nvim-java-dap',
				'nvim-java/nvim-java',
				'JavaHello/spring-boot.nvim',
			} } use { "mfussenegger/nvim-dap" } use {'dart-lang/dart-vim-plugin'}
		use {
			"brymer-meneses/grammar-guard.nvim",
			requires = {
				"neovim/nvim-lspconfig",
				"williamboman/nvim-lsp-installer"
			}
		}
		use {
			'SCJangra/table-nvim',
			ft = 'markdown',
			config = function()
				require('table-nvim').setup({
					padd_column_separators = true,
					disable_defaults = true, -- ✅ disables default mappings
					mappings = {
						next = '<TAB>',
						prev = '<S-TAB>',
						insert_row_up = '<A-k>',
						insert_row_down = '<Leader>jj',
						move_row_up = '<A-S-k>',
						move_row_down = '<A-S-j>',
						insert_column_left = '<A-h>',
						insert_column_right = '<A-l>',
						move_column_left = '<A-S-h>',
						move_column_right = '<A-S-l>',
						insert_table = '<A-t>',
						insert_table_alt = '<A-S-t>',
						delete_column = '<A-d>',
					}
				})
			end
		}

		-- Auto-sync on first bootstrap
		if packer_bootstrap then
			packer.sync()
		end
	end)

else
	print("Packer is not installed");
end
