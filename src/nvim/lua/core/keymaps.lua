vim.keymap.set("n", "<Leader><Up>", "<C-w>k")
vim.keymap.set("n", "<Leader><Left>", "<C-w>h")
vim.keymap.set("n", "<Leader><Down>", "<C-w>j")
vim.keymap.set("n", "<Leader><Right>", "<C-w>l")

-- vim.keymap.set("n", "<Leader>j", ":bprevious<CR>", { silent = true })
-- vim.keymap.set("n", "<Leader>k", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":bdelete<CR>", { silent = true })

vim.keymap.set("n", "<Leader>y", ":%y<CR>")
vim.keymap.set("n", "<Leader>v", ":edit ~/.config/home-manager/src/nvim<CR>")

vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })
