return {
   {
      "RaafatTurki/hex.nvim",
      opts = {},
      config = function()
         require("hex").setup()
         vim.api.nvim_create_user_command("HEX", function() require("hex").toggle() end, {})
      end,
   }
}
