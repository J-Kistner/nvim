function get_parent()
   local current_node = vim.treesitter.get_node()
   if not current_node then
      return
   end

   local srow, scol = current_node:start()
   local erow, ecol = current_node:end_()

   local buffer = vim.fn.bufnr()

   vim.api.nvim_buf_set_text(buffer, srow, scol, srow, scol, { "Some(" });
   vim.api.nvim_buf_set_text(buffer, erow, ecol + 5, erow, ecol, { ")" });
end

get_parent()
