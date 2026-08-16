return {
   {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-mini/mini.icons",
      },
      config = function()
         require("render-markdown").setup({
            -- Disable markdown highlighting when working with large files
            file_types = { "markdown", "quarto", "rmd" },
            -- Disable inject languages to avoid treesitter-context issues with markdown injections
            render = {
               code = { position = "overlay", width = "block" },
            },
         })
      end,
   }
}
