


-- vim.keymap.set( "n", "<leader>th", _return_type )

-- function return_type( type ) 
--
--    local buffer = vim.fn.bufnr()
--    local current_node = vim.treesitter.get_node { ignore_injections = false }
--    if not current_node then
--       return
--    end
--
--    local funtion_node = find_node_ancestor( { "function_defintion" }, current_node )
--    if not funtion_node then
--       return
--    end
--
--    local return_node = nc( { "type" }, function_node )
--    if not return_node then
--
--       local parameter_node = nc( { "parameters" }, function_node )
--       if not parameter_node then
--          return
--       end
--
--       vim.api.nvim_feedkeys( "1", "n", true )
--
--       local end_row, end_column = parameter_node:end_()
--
--       vim.api.nvim_buf_set_text( buffer, end_row, end_column, end_row, end_column, { " -> " .. type } )
--
--       return
--    end
--
--    local return_start_row, return_start_col = return_node:start()
--    local return_end_row, return_end_col = return_node:end_()
--
--    vim.api.nvim_buf_set_text( buffer, return_start_row, return_start_col, return_end_row, return_end_col, { type } )
--
-- end
--
-- vim.keymap.set( "n", "r", vim.ui.input( { prompt = "Enter typing" }, return_type ) )
