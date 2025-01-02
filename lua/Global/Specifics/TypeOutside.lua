-- This function essentialy creates two cursors on the outside of your current selected text that move away and miror certain charecters like ( or [

function TypeOutside()
   local mode = vim.api.nvim_get_mode()[ "mode" ]
   if not mode == "v" then
      return
   end
   local buffer = vim.fn.bufnr()
   return
end

vim.keymap.set( "v", "<S-i>", function()
   TypeOutside() 
end )
