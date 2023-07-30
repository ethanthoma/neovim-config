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
    use 'jghauser/mkdir.nvim'

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
    use 'sunjon/shade.nvim'
    use 'winston0410/range-highlight.nvim'
    use {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup {}
        end
    }

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
    use 'f-person/git-blame.nvim'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {}
        end
    }

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
    use {
        'gelguy/wilder.nvim',
        config = function()
            -- config goes here
        end,
    }

    -- Install R terminal
    use 'jalvesaq/Nvim-R'
end)

