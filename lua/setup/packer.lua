-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Fuzzy file finder
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Theme
    use { 'rose-pine/neovim', as = 'rose-pine' }
    vim.cmd('colorscheme rose-pine')

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,}
        use 'nvim-treesitter/playground'
        use 'nvim-treesitter/nvim-treesitter-context'

        -- Version control
        use 'mbbill/undotree'

        -- File navigation
        use 'theprimeagen/harpoon'

        -- Prettier netrw
        use 'prichrd/netrw.nvim'
        use 'nvim-tree/nvim-web-devicons'
        -- Better netrw navigation
        use 'tpope/vim-vinegar'

        -- Git commands
        use 'tpope/vim-fugitive'

        -- Auto saving
        use 'tpope/vim-obsession'

        -- LSP
        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v1.x',
            requires = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},
                {'williamboman/mason.nvim'},
                {'williamboman/mason-lspconfig.nvim'},

                -- Autocompletion
                {'hrsh7th/nvim-cmp'},
                {'hrsh7th/cmp-buffer'},
                {'hrsh7th/cmp-path'},
                {'saadparwaiz1/cmp_luasnip'},
                {'hrsh7th/cmp-nvim-lsp'},
                {'hrsh7th/cmp-nvim-lua'},

                -- Snippets
                {'L3MON4D3/LuaSnip'},
                {'rafamadriz/friendly-snippets'},
            }
        }

        -- Prettier
        use {
            "folke/trouble.nvim",
            config = function()
                require("trouble").setup {
                }
            end
        }

        -- Install R terminal
        use 'jalvesaq/Nvim-R'
    end)

