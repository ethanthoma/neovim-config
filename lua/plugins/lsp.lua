return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Format
        { 'lukas-reineke/lsp-format.nvim' },
        { "stevearc/conform.nvim" },

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
        require("lsp-format").setup({})

        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP actions",
            callback = function(event)
                local opts = { buffer = event.buf }

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


                local id = vim.tbl_get(event, 'data', 'client_id')
                local client = id and vim.lsp.get_client_by_id(id)
                if client == nil then
                    return
                end

                if client.supports_method('textDocument/formatting') then
                    require('lsp-format').on_attach(client)
                end
            end,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })

        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = ' ',
                    [vim.diagnostic.severity.WARN] = ' ',
                    [vim.diagnostic.severity.HINT] = ' ',
                    [vim.diagnostic.severity.INFO] = ' ',
                },
            },
        })

        require("conform").setup({
            formatters_by_ft = {
                nix = { "nixfmt" },
                rust = { "rustfmt" },
                gleam = { "gleam" },
                json = { "jq" },
            },
        })

        local lsp_configurations = require('lspconfig.configs')

        if vim.fn.executable("lua-language-server") == 1 then
            require("lspconfig")["lua_ls"].setup({
                settings = { diagnostics = { globals = { "vim" } } }
            })
        end

        if vim.fn.executable("haskell-language-server") == 1 then
            require("lspconfig")["hls"].setup({
                cmd = { "haskell-language-server", "--lsp" }
            })
        end

        if vim.fn.executable("rust-analyzer") == 1 then
            require("lspconfig")["rust_analyzer"].setup({})
        end

        if vim.fn.executable("harper-ls") == 1 then
            require("lspconfig")["harper_ls"].setup({})
        end

        if vim.fn.executable("ols") == 1 then
            require("lspconfig")["ols"].setup({})
        end

        if vim.fn.executable("pylyzer") == 1 then
            require("lspconfig")["pylyzer"].setup({})
        end

        if vim.fn.executable("ruff") == 1 then
            require("lspconfig")["ruff"].setup({})
        end

        if vim.fn.executable("gleam") == 1 then
            require("lspconfig")["gleam"].setup({})
        end

        if vim.fn.executable("typescript-language-server") == 1 then
            require("lspconfig")["ts_ls"].setup({})
        end

        require("mason").setup()
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup {}
            end,
        }

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
