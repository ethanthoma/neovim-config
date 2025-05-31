return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Linters
        { "mfussenegger/nvim-lint" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        vim.api.nvim_create_autocmd('LspAttach', {
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
            end,
        })

        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
        })

        -- Languages

        vim.filetype.add({
            extension = {
                flix = "flix",
            },
        })

        -- LSPs

        local servers = {
            lua_ls = {
                executable = "lua-language-server",
                config = {
                    settings = { Lua = { diagnostics = { globals = { "vim" } } } }
                },
            },
            hls = {
                executable = "haskell-language-server",
                config = {
                    cmd = { "haskell-language-server", "--lsp" }
                },
            },
            rust_analyzer = { executable = "rust-analyzer", },
            ols = { executable = "ols", },
            pylyzer = { executable = "pylyzer", },
            ruff = { executable = "ruff", },
            gleam = { executable = "gleam", },
            ts_ls = { executable = "typescript-language-server", },
            superhtml = { executable = "superhtml", },
            nil_ls = {
                executable = "nil",
                config = { ["nil"] = { formatting = { command = { "nixfmt" }, }, }, },
            },
            nickel_ls = { executable = "nls" },
            gopls = { executable = "gopls" },
            golangci_lint_ls = { executable = "golangci-lint-langserver" },
            templ = { executable = "templ" },
            htmx = { executable = "htmx-lsp" },
            zls = { executable = "zls" },
            wgsl_analyzer = { executable = "wgsl_analyzer" },
            kotlin_language_server = { executable = "kotlin-language-server" },
            pyre = { executable = "pyre" },
            pyright = { executable = "pyright" },
            tailwindcss = {
                executable = "tailwindcss-language-server",
                config = {
                    root_dir = function(fname)
                        local root_file = {
                            'tailwind.config.js',
                            'tailwind.config.cjs',
                            'tailwind.config.mjs',
                            'tailwind.config.ts',
                            'postcss.config.js',
                            'postcss.config.cjs',
                            'postcss.config.mjs',
                            'postcss.config.ts',
                            'flake.nix',
                        }
                        root_file = require('lspconfig.util').insert_package_json(root_file, 'tailwindcss', fname)
                        return require('lspconfig.util').root_pattern(unpack(root_file))(fname)
                    end,
                },
            },
            flix = {
                executable = "flix",
                default = {
                    cmd = { "flix", "lsp" },
                    filetypes = { "flix" },
                    root_dir = function(fname)
                        return vim.fs.dirname(vim.fs.find({ "flix.toml", "flix.jar" }, { path = fname, upward = true })
                            [1]) or vim.fs.dirname(fname)
                    end,
                    settings = {},
                },
                config = {
                    capabilities = vim.lsp.protocol.make_client_capabilities(),
                    on_attach = function(client, bufnr)
                        print("Flix LSP attached to buffer " .. bufnr)

                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format { bufnr = bufnr, async = false, id = client.id }
                            end,
                        })
                    end,
                    flags = {},
                },
            },
            ty = {
                executable = "ty",
                default = {
                    cmd = { "ty", "server" },
                    filetypes = { "python" },
                    root_markers = { ".git", "pyproject.toml" },
                },
                config = {
                    init_options = {
                        settings = {}
                    }
                },
            },
            tinymist = {
                executable = "tinymist",
                default = {
                    cmd = { "tinymist" },
                    filetypes = { "typst" },
                    settings = {
                        -- ...
                    },
                },
            },
        }

        for server_name, settings in pairs(servers) do
            if vim.fn.executable(settings.executable) == 1 then
                if settings.default then
                    vim.lsp.config(server_name, settings.default)
                end

                if settings.config then
                    local config = vim.lsp.config[server_name]

                    for k, v in pairs(settings.config) do config[k] = v end

                    vim.lsp.config(server_name, config)
                end

                vim.lsp.enable(server_name)
            end
        end

        -- Linters

        require("lint").linters_by_ft = {
            javascript = { "oxlint" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end,
}
