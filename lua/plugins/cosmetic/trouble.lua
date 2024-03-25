return {
	'folke/trouble.nvim',
    opts = {
        auto_open = true,
        auto_close = true,
        use_diagnostic_signs = true,
    },
	config = function ()
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
            {silent = true, noremap = true}
        )
	end,
}

