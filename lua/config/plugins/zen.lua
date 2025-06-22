return {
   "folke/zen-mode.nvim",
   opts = {
      on_open = function(win)
         vim.o.winborder = "rounded"
      end,
   },
   config = function()
      vim.api.nvim_create_user_command("Zen", function()
         vim.o.winborder = "none"
         vim.cmd("ZenMode")
      end, {})
   end
}
