return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            nix = { "nixfmt" },
            rust = { "rustfmt" },
            gleam = { "gleam" },
            json = { "jq" },
            javascript = { "biome" },
            html = { "superhtml" },
            python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
            nickel = { "nickel" },
            zig = { "zig" },
            inko = { "inko" },
        },

        formatters = {
            nickel = {
                command = "nickel",
                stdin = true,
                args = { "format" },
            },
        },

        default_format_opts = {
            lsp_format = "fallback",
        },

        format_on_save = { timeout_ms = 500 },
    },
}
