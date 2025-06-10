return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        keywords = {
            FIX = {
                icon = " ",
                color = "error",
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        colors = {
            error = { "DiagnosticError", "ErrorMsg", "#eb6f92" },
            warning = { "DiagnosticWarn", "WarningMsg", "#f6c177" },
            info = { "DiagnosticInfo", "#ebbcba" },
            hint = { "DiagnosticHint", "#31748f" },
            default = { "Identifier", "#9ccfd8" },
            test = { "Identifier", "#c4a7e7" }
        },
    },
}
