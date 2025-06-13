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
            menu = { border = 'rounded' },
            documentation = { window = { border = 'rounded' } },
         },
         signature = { window = { border = 'rounded' } },
      },
      sourcess = {
         default = { "lsp", "path", "snippets", "buffer" },
      },
   }
}
