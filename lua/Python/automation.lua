vim.keymap.set( "i", " ", function()
   vim.api.nvim_feedkeys( " ", "n", true )
   add_self()
   check_pass()
   add_async()
   --  return_type()
end ) 
vim.keymap.set( "n", "<leader>th", function()
   return_type()
end )