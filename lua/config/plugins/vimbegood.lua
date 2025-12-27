vim.api.nvim_create_user_command("VimBeGooder", function()
   vim.o.winborder = "rounded"
   vim.cmd("VimBeGood")
end, {}
)
return {
   "theprimeagen/vim-be-good"
}
