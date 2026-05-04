return {
   {
      "nvim-lua/plenary.nvim",
      lazy = false,
   },
   {
      "ThePrimeagen/refactoring.nvim",
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
      },
      lazy = false,
      opts = {},
       config = function()
          -- Ensure plenary's async module is available
          package.loaded['async'] = require('plenary.async')
          require('refactoring').setup({
             prompt_func_return_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
             },
             prompt_func_param_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
             },
             printf_statements = {},
             print_var_statements = {},
             show_success_message = false, -- shows a message with information about the refactor on success

          })

          vim.keymap.set({"n", "v", "x"}, "<leader>re", ":Refactor extract", { desc = "( Refactor ) Extract" })                             -- Extracts highlighted text to new function
          vim.keymap.set({"n", "v", "x"}, "<leader>rf", ":Refactor extract_to_file", { desc = "( Refactor ) Extract to File" })             -- Extracts to a new function in a new file
          vim.keymap.set({"n", "v", "x"}, "<leader>rv", ":Refactor extract_var", { desc = "( Refactor ) Extract Var" })                     -- Extracts expression to variable
          vim.keymap.set({"n", "v", "x"}, "<leader>ri", ":Refactor inline_var", { desc = "( Refactor ) Inline Var" })                       -- Replaces all use of a variable with its definition
          vim.keymap.set({"n", "v", "x"}, "<leader>rI", ":Refactor inline_func", { desc = "( Refactor ) Inline Func" })                     -- Replaces all uses of a function with its definiton
          vim.keymap.set({"n", "v", "x"}, "<leader>rb", ":Refactor extract_block", { desc = "( Refactor ) Extract Block" })                 -- No clue yet
          vim.keymap.set({"n", "v", "x"}, "<leader>rB", ":Refactor extract_block_to_file", { desc = "( Refactor ) Extract Block to File" }) -- No clue yet
       end

   },
}
