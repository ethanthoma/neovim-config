return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
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

        lsp_zero.set_preferences({
            sign_icons = {
                error = ' ',
                warn = ' ',
                hint = ' ',
                info = ' ',
            },
        })

        lsp_zero.on_attach(function(_, bufnr)
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
        end)

        local lsp_configurations = require('lspconfig.configs')

        if vim.loop.os_uname().sysname == "Linux" then
            local command = [[
                source /etc/os-release;
                echo $NAME
            ]]
            local handle = io.popen(command)
            if handle ~= nil then
                local distro = handle:read("*a")

                if distro:match("NixOS") ~= nil and
                    vim.fn.executable('lua-language-server') == 1 and
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

                handle:close()
            end
        end

        -- ocaml
        if vim.fn.executable('ocamllsp')
        then
            lsp_configurations.ocamllsp = {
                default_config = {
                    name = 'ocamllsp',
                    cmd = { 'ocamllsp' },
                    filetypes = { 'ocaml', 'ml', 're' },
                    root_dir = require('lspconfig.util').root_pattern('*.opam')
                }
            }
            require('lspconfig').ocamllsp.setup({})
        end

        -- gleam
        if not lsp_configurations.gleam and
            vim.fn.executable('gleam')
        then
            lsp_configurations.gleam = {
                default_config = {
                    name = 'gleam',
                    cmd = { 'gleam', 'lsp' },
                    filetypes = { 'gleam' },
                    root_dir = require('lspconfig.util').root_pattern('gleam.toml')
                }
            }
            require('lspconfig').gleam.setup({})

            if not lsp_configurations.glas and
                vim.fn.executable('glas')
            then
                lsp_configurations.glas = {
                    default_config = {
                        name = 'glas',
                        cmd = { 'glas', '--stdio' },
                        filetypes = { 'gleam' },
                        root_dir = require('lspconfig.util').root_pattern('gleam.toml')
                    }
                }
                require('lspconfig').glas.setup({})
            end

            vim.api.nvim_create_user_command('FormatAndSaveGleam', function()
                vim.cmd('write')
                vim.cmd('silent !gleam format %')
                vim.cmd('edit!')
                vim.cmd('write')
            end, {})

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.gleam",
                callback = function()
                    vim.cmd('FormatAndSaveGleam')
                end,
            })
        end

        require('mason').setup({})
        require('mason-lspconfig').setup({
            handlers = {
                lsp_zero.default_setup,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    require('lspconfig').lua_ls.setup(lua_opts)
                end,
            },
        })

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lua' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'buffer',  keyword_length = 3 },
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
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
