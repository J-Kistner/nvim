-- vim.g.maplocalleader = "\\"


-- File Navigation
-- Key("n", "<Leader>ft", function() vim.cmd("Ex") end, "Opens the file tree.") -- Replaced with oil.nvim
Key(
   "n",
   "<Leader>ft",
   function()
      vim.cmd("Oil")
      -- require("config.Oil.oilnvim-logo").open()
   end,
   "Opens the file tree."
) -- Replaced with oil.nvim

-- Better Indentation
Key("i", "<S-Tab>", function() vim.cmd("norm <<") end, "Unindent")
Key("n", "<Tab>", ">>", "Indent")
Key("n", "<S-Tab>", "<<", "Unindent")
Key("v", "<Tab>", ">", "Indent")
Key("v", "<S-Tab>", "<", "Unindent")

-- Generil Util
Key("vi", "<C-c>", "<Esc>", "Allows for <C-c> to exit multiline.")
Key(
   "n",
   "<leader><leader>",
   function()
      vim.cmd("so")
      vim.cmd("Lazy")
   end,
   "Refreshes the config and the current file."
)

Key("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace")

-- Formatting
Key("n", "<leader>fo", vim.lsp.buf.format, "Formats the file")

-- Navigation
Key("n", "E", "2be", "Moves to the end of the last word.")
Key("v", "J", ":m '>+1<CR>gv=gv", "Move block in visual mode")
Key("v", "K", ":m '<-2<CR>gv=gv", "Move block in visual mode")
Key("n", "J", "mzJ`z", "Cursor stays in place when merging lines")
Key("n", "K", "mzK`z", "Cursor stays in place when merging lines")
Key("n", "<C-d>", "<C-d>zz", "Center screen after half page jump. ")
Key("n", "<C-u>", "<C-u>zz", "Center screen after half page jump. ")
Key("n", "n", "nzzzv", "Center after find next")
Key("n", "N", "Nzzzv", "Center after find next")
Key("n", "<leader>j", "<cmd>lnext<CR>zz", "Random Jump idrk")
Key("n", "<leader>k", "<cmd>lprev<CR>zz", "Random Jump idrk")

-- Better Bin Management
Key("nv", "<leader>d", "\"_d", "A delete that does not store the result.") -- TODO: Learn to press backslash
Key("n", "<leader>P", "viwp", "Pastes inside the current word.")
Key("x", "<leader>p", [["_dp]], "Paste from trash buffer.")
Key("nvx", "<leader>y", "\"+y", "Yank to copy buffer.")

-- I can't type backslash
Key("i", "<F8>", "\\", "Types the backslash charecter")

-- QuickFix
Key("n", "<leader>co", function() vim.cmd("copen") end, "( QuickFix ) Opens a QuickFix")
Key("n", "<leader>cc", function() vim.cmd("cclose") end, "( QuickFix ) Closes a QuickFix")
Key("n", "<C-j>", "<cmd>cnext<CR>zz", "Quick Fix Jump")
Key("n", "<C-k>", "<cmd>cprev<CR>zz", "Quick Fix Jump")
-- Look at cdo

-- Terminal
Key("t", "<C-c>", "<C-\\><C-n>", "Closes the terminal")

Key("vn", "<PageDown>", "$", "PgDown moves to the end of the line")
Key("vn", "<PageUp>", "%", "PgUp moves to the start of the chars")

Key("n", "<C-l>", function() vim.cmd("checktime") end, "Reloads the file")

-- Happy
vim.keymap.set({ "n", "x" }, "j", function()
   return vim.v.count == 0 and "gj" or "j"
end, { expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
   return vim.v.count == 0 and "gk" or "k"
end, { expr = true })

vim.keymap.set("n", "<C-L>", "<C-I>", { desc = "Jump Forwards", noremap = false })

-- Wrap

WRAP_SET_MANUALLY = false

Key("n", "<leader>wy", function()
   vim.opt.wrap = true
   WRAP_SET_MANUALLY = true
end, "(Wrap) Yes")

Key("n", "<leader>wn", function()
   vim.opt.wrap = true
   WRAP_SET_MANUALLY = true
end, "(Wrap) No")

vim.api.nvim_create_autocmd("BufEnter", {
   pattern = "*.txt",
   callback = function()
      if not WRAP_SET_MANUALLY then
         vim.opt.wrap = true
      end
   end
})

vim.api.nvim_create_autocmd("BufLeave", {
   pattern = "*.txt",
   callback = function()
      if not WRAP_SET_MANUALLY then
         vim.opt.wrap = false
      end
   end
})
