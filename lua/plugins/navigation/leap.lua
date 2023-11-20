return {
    'ggandor/leap.nvim',
    config = function()
        require('leap').add_default_mappings()
        require('leap').opts.safe_labels = {}
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end
}

