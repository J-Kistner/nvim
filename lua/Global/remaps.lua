vim.g.mapleader = " "
vim.keymap.set("i", "<C-n>", "<C-x><C-o>")
vim.keymap.set("n", "<leader>en", "<CR>")
vim.keymap.set("n", "<leader>p", "viwp")
vim.keymap.set("n", "E", "2be")
vim.keymap.set("v", "<Tab>", ">")
vim.keymap.set("n", "<leader>ip", require("lspimport").import)
vim.keymap.set("n", "<C-w>H", function()
   vim.cmd("!tmux last")
end)
vim.keymap.set("n", "<C-w>L", function()
   vim.cmd("!tmux next")
end)
vim.keymap.set("n", "<leader>ft", function()
   vim.cmd("Ex")
end)
vim.keymap.set("n", "<enter>", "mao<esc>`a")
vim.keymap.set("n", "yp", "yyp")
vim.keymap.set("n", "yP", "yyP")
vim.keymap.set("n", "!", ":!")
vim.keymap.set("n", "<leader>ts", function()
   vim.cmd("TSP")
end)
vim.keymap.set("v", "\"", ":s/\\%V.*\\%V./\"&\"<enter>")
vim.keymap.set("n", "<leader>r", function()
   vim.api.nvim_feedkeys("viw:%s/\\%V.*\\%V./", "n", true)
end)
vim.keymap.set("n", "<tab>", ">>")
vim.keymap.set("n", "<S-Tab>", "<<")
vim.keymap.set("v", "<S-Tab>", "<")
vim.keymap.set("i", "<S-Tab>", function()
   vim.cmd("norm <<")
end)
vim.keymap.set("n", "<leader>wl", "<C-w>l")
vim.keymap.set("n", "<leader>wj", "<C-w>j")
vim.keymap.set("n", "<leader>wk", "<C-w>k")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- vim.keymap.set( "n", "<leader>zig", "<cmd>LspRestart<cr>")
vim.keymap.set("i", "<C-c>", "<esc>")
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dp]])
-- next greatest remap ever :
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
   vim.cmd("so")
   vim.cmd("PackerSync")
end)
