return {
    'folke/trouble.nvim',
    opts = {
        auto_open = true,
        auto_close = true,
        use_diagnostic_signs = true,
    },
    cmd = "Trouble",
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
    },
}
