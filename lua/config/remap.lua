-- Remap leader
vim.g.mapleader = " "
-- Open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selection up or down with J or K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor place after performing J
vim.keymap.set("n", "J", "mzJ`z")
-- Keep cursor with half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Keep cursor when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Pasting without replacing buffer
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Delete to void
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Yank to system buffer
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- For vertical edit
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Switch sessions via sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww sessionizer<CR>")

-- Quick fix nav
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace current cursor word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Max current script executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- :so with ease
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

