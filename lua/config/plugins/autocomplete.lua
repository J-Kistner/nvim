return {
   {
      "saghen/blink.cmp",
      dependencies = {
         "rafamadriz/friendly-snippets",
      },
      version = "v0.*",
      opts = {
         keymap = {
            preset = "default",
            ["<C-space>"] = { "accept" },
            ["<C-k>"] = {},

         },
         appearance = {
            highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
         },
         completion = {
            -- ghost_text = { enabled = true },
            menu = { border = 'rounded' },
            documentation = { auto_show = true, window = { border = 'rounded' } },
         },

         signature = { enabled = true, window = { show_documentation = true, } },
         sources = {
            default = { "lsp", "path", "snippets", "buffer", },
         },
      }
   },
}
