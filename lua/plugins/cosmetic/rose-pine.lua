return {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
        require('rose-pine').setup({
            variant = 'moon',
            disable_background = true,
            disable_float_background = true,
            highlight_groups = {
                TelescopeBorder = { fg = "highlight_high", bg = "none" },
                TelescopeNormal = { bg = "none" },
                TelescopePromptNormal = { bg = "base" },
                TelescopeResultsNormal = { fg = "subtle", bg = "none" },
                TelescopeSelection = { fg = "text", bg = "base" },
                TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
            }
        })

        vim.cmd('colorscheme rose-pine')

        vim.cmd [[
            highlight Visual guibg = #56526e
        ]]

        vim.cmd [[
            highlight LineNr guifg=#e0def4
            highlight CursorLineNr guifg=#e0def4
        ]]
    end,
}
