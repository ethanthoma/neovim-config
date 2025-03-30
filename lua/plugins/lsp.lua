return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    dependencies = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },

        -- Linters
        { "mfussenegger/nvim-lint" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },

        -- Lang Plugins
        { "inko-lang/inko.vim" },
    },
    config = function()
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
            harper_ls = { executable = "harper-ls", },
            ols = { executable = "ols", },
            pylyzer = { executable = "pylyzer", },
            ruff = { executable = "ruff", },
            gleam = { executable = "gleam", },
            ts_ls = { executable = "typescript-language-server", },
            superhtml = { executable = "superhtml", },
            nil_ls = {
                executable = "nil",
                config = {
                    ["nil"] = {
                        formatting = { command = { "nixfmt" }, },
                    },
                },
            },
            nickel_ls = { executable = "nls" },
            gopls = { executable = "gopls" },
            golangci_lint_ls = { executable = "golangci-lint-langserver" },
            templ = { executable = "templ" },
            htmx = { executable = "htmx-lsp" },
            zls = { executable = "zls" },
            wgsl_analyzer = { executable = "wgsl_analyzer" },
            tailwindcss = { executable = "tailwindcss-language-server" },
        }

        for server_name, settings in pairs(servers) do
            if vim.fn.executable(settings.executable) == 1 then
                local config = settings.config

                if config == nil then
                    config = {}
                end

                require("lspconfig")[server_name].setup(config)
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
