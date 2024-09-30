return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },

        -- Snippets
        { 'L3MON4D3/LuaSnip' },
        { 'hrsh7th/cmp-vsnip' },
        { 'hrsh7th/vim-vsnip' },
        { 'rafamadriz/friendly-snippets' },
        { 'saadparwaiz1/cmp_luasnip' },

        -- Telescope extensions
        { 'nvim-telescope/telescope-media-files.nvim' },
    },
    config = function()
        local lsp_zero = require("lsp-zero")

        local lsp_attach = function(_, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

            lsp_zero.buffer_autoformat()
        end

        lsp_zero.extend_lspconfig({
            sign_text = {
                error = ' ',
                warn = ' ',
                hint = ' ',
                info = ' ',
            },
            lsp_attach = lsp_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })

        require("mason").setup()
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup {}
            end,
        }

        local lsp_configurations = require('lspconfig.configs')

        if vim.loop.os_uname().sysname == "Linux" then
            local command = [[
                source /etc/os-release;
                echo $NAME
            ]]
            local handle = io.popen(command)
            if handle ~= nil then
                local distro = handle:read("*a")

                if distro:match("NixOS") ~= nil then
                    if vim.fn.executable('lua-language-server') == 1 and
                        not lsp_configurations.lua_lsp
                    then
                        lsp_configurations.lua_lsp = {
                            default_config = {
                                name = 'lua-language-server',
                                cmd = { 'lua-language-server' },
                                filetypes = { 'lua' },
                                root_dir = require('lspconfig.util').root_pattern('init.lua')
                            }
                        }
                        require('lspconfig').lua_lsp.setup({})
                    end
                end

                handle:close()
            end
        end

        if vim.fn.executable('nixfmt')
        then
            vim.api.nvim_create_user_command('FormatAndSaveNix', function()
                vim.cmd('write')
                vim.cmd('silent !nixfmt %')
                vim.cmd('edit!')
                vim.cmd('write')
            end, {})

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.nix",
                callback = function()
                    vim.cmd('FormatAndSaveNix')
                end,
            })
        end

        if
            vim.fn.executable('ols') == 1 and
            not lsp_configurations.ols
        then
            lsp_configurations.ols = {
                default_config = {
                    name = 'ols',
                    cmd = { 'ols' },
                    filetypes = { 'odin' },
                    root_dir = require('lspconfig.util').root_pattern('flake.nix')
                }
            }
            require('lspconfig').ols.setup({})
        end

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lua' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'buffer',  keyword_length = 3 },
                { name = "copilot", group_index = 2 },
            },
            experimental = {
                ghost_text = true,
            },
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            formatting = lsp_zero.cmp_format(),
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<Tab>'] = nil,
                ['<S-Tab>'] = nil,
            }),
        })
    end,
}
