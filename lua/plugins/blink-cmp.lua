return {
    "saghen/blink.cmp",
    dependencies = {
        { "L3MON4D3/LuaSnip", version = "v2.*" },
    },

    version = "1.*",
    build = "nix run .#build-plugin",

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },

        appearance = {
            nerd_font_variant = "mono"
        },

        completion = {
            documentation = { auto_show = false },
            ghost_text = { enabled = true },
        },

        snippets = { preset = 'luasnip' },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" },
}
