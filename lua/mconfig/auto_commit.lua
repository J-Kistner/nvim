M = {}

M.setup = function()
   vim.api.nvim_create_augroup("auto_commit", { clear = true })
   vim.api.nvim_create_autocmd("BufWritePost", {
      group = "auto_commit",
      callback = function()
         M.call_for_committer()
      end,
   })
end

M.call_for_committer = function()
   -- local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
   -- local relative = vim.fn.fnamemodify(filepath, ":.")
   --
   -- vim.system(
   --    {
   --       "opencode",
   --       "run",
   --       "--agent",
   --       "committer",
   --       "--dangerously-skip-permissions",
   --       relative .. " has been saved. Stage this file and create a commit with an appropriate message summarizing the changes.",
   --    },
   --    { text = true },
   --    function(result)
   --       if result.code ~= 0 then
   --          vim.notify("opencode commit failed: " .. (result.stderr or ""), vim.log.levels.ERROR, { title = "auto_commit" })
   --       end
   --    end
   -- )
end

M.setup()
