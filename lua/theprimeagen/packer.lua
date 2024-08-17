-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself:h pa
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function () 
            vim.cmd('colorscheme rose-pine')
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' 
    }

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

    use {
        'nvim-tree/nvim-tree.lua',
    }

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

    use { "vim-airline/vim-airline" }
    use { "vim-airline/vim-airline-themes" }
    use { "preservim/tagbar" }
    use { "Lokaltog/vim-powerline" }
    use { "cohama/lexima.vim" }
    use {
        'VonHeikemen/fine-cmdline.nvim',
        requires = {
            {'MunifTanjim/nui.nvim'}
        }
    }
    use {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                config = {
                    week_header = {
                        enable = true,
                    },
                    shortcut = {
                        { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        {
                            desc = ' Apps',
                            group = 'DiagnosticHint',
                            action = 'Telescope app',
                            key = 'a',
                        },
                        {
                            desc = ' dotfiles',
                            group = 'Number',
                            action = 'Telescope dotfiles',
                            key = 'd',
                        },
                    },
                },
            }
        end,
        requires = {'nvim-tree/nvim-web-devicons'}
    }
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
end)
