return {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            skip_confirm_for_simple_edits = true,
            delete_to_trash = true,
            view_options = {
                show_hidden = true,
            },
            watch_for_changes = true,
        })
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

        require("nvim-web-devicons").setup({
            override_by_extension = {
                ["ncl"] = {
                    icon = "󰆧",
                    color = "#E0C3FC",
                    cterm_color = "189",
                    name = "nickel",
                },
            },
        })
    end
}
