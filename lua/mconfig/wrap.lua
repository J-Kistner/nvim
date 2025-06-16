function wrap_some()
   local current_node = vim.treesitter.get_node()
   if not current_node then
      return
   end

   local srow, scol = current_node:start()
   local erow, ecol = current_node:end_()

   local buffer = vim.fn.bufnr()

   vim.api.nvim_buf_set_text(buffer, srow, scol, srow, scol, { "Some(" });
   vim.api.nvim_buf_set_text(buffer, erow, ecol + 5, erow, ecol + 5, { ")" });
end

function wrap_ok()
   local current_node = vim.treesitter.get_node()
   if not current_node then
      return
   end

   local srow, scol = current_node:start()
   local erow, ecol = current_node:end_()

   local buffer = vim.fn.bufnr()

   vim.api.nvim_buf_set_text(buffer, srow, scol, srow, scol, { "Ok(" });
   vim.api.nvim_buf_set_text(buffer, erow, ecol + 3, erow, ecol + 3, { ")" });
end

function wrap_err()
   local current_node = vim.treesitter.get_node()
   if not current_node then
      return
   end

   local srow, scol = current_node:start()
   local erow, ecol = current_node:end_()

   local buffer = vim.fn.bufnr()

   vim.api.nvim_buf_set_text(buffer, srow, scol, srow, scol, { "Ok(" });
   vim.api.nvim_buf_set_text(buffer, erow, ecol + 3, erow, ecol + 3, { ")" });
end

Key("n", "<leader>ws", get_parent, "Wrap current node in Some()")
Key("n", "<leader>wo", wrap_ok, "Wrap current node in Ok()")
Key("n", "<leader>we", wrap_err, "Wrap current node in Err()")
