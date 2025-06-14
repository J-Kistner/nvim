return {
   {
      "saghen/blink.cmp",
      dependencies = "rafamadriz/friendly-snippets",
      version = "v0.*",
      opts = {
         keymap = {
            preset = "default",
            ["<C-space>"] = { "accept" },

         },
         appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "normal",
         },
         completion = {
            -- ghost_text = { enabled = true },
            menu = { border = 'rounded' },
            documentation = { auto_show = true, window = { border = 'rounded' } },
         },
         signature = { enabled = true, window = { border = 'rounded' } },
      },
      sources = {
         default = { "lsp", "path", "snippets", "buffer" },
      },
   }
}
