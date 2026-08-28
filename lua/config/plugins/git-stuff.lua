return {
   {
      "tpope/vim-fugitive",
      config = function()
         Key("n", "<leader>GG", function()
            vim.cmd("Git")
         end, "( Vim-Fugitive ) Open Git Main Menu")

         Key("n", "<leader>Gm", function()
            vim.cmd("Git mergetool")
         end, "( Vim-Fugitive ) Open Git Mergetool")

         Key("n", "<leader>Gc", function()
            vim.cmd("Git commit")
         end, "( Vim-Fugitive ) Git Commit")

         Key("n", "<leader>Gp", function()
            vim.cmd("Git push")
         end, "( Vim-Fugitive ) Git Push")

         Key("n", "<leader>GP", function()
            vim.cmd("Git pull")
         end, "( Vim-Fugitive ) Git Pull")

         Key("n", "<leader>Ga", function()
            vim.cmd("Git add .")
         end, "( Vim-Fugitive ) Git Add All")
      end
   }
}
