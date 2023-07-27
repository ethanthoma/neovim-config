-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Navigation and finding
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'theprimeagen/harpoon'
    use 'christoomey/vim-tmux-navigator'
    use 'tpope/vim-vinegar'

    -- Prettier
    use { 'rose-pine/neovim', as = 'rose-pine' }
    vim.cmd('colorscheme rose-pine')
    use {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                use_diagnostic_signs = true
            }
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use 'prichrd/netrw.nvim'
    use 'nvim-tree/nvim-web-devicons'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    }
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-context'

    -- Version control
    use 'mbbill/undotree'

    -- Git commands
    use 'tpope/vim-fugitive'
    use 'ThePrimeagen/git-worktree.nvim'

    -- Auto saving
    use 'tpope/vim-obsession'

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
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

            -- Telescope extensions
            {'nvim-telescope/telescope-frecency.nvim'},
            {'nvim-telescope/telescope-media-files.nvim'},
        }
    }

    -- Install R terminal
    use 'jalvesaq/Nvim-R'
end)

