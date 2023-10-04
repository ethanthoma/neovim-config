-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- 4 space indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- No wraps
vim.opt.wrap = false

-- Long undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Better search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colours
vim.opt.termguicolors = true

-- 8 row top-bottom buffer
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Fast updates
vim.opt.updatetime = 50

-- 80 width columns
vim.opt.colorcolumn = "80"

