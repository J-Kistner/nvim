return {
   {
      "stevearc/oil.nvim",
      --@module "oil"
      --@type oil.SetupOpts
      opts = {
         view_options = {
            show_hidden = true,
         },
         keymaps = {
            ["<CR>"] = "actions.select",
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = { "actions.close", mode = "n" },
            ["<C-l>"] = "actions.refresh",
            ["-"] = { "actions.parent", mode = "n" },
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["`"] = { "actions.cd", mode = "n" },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["g."] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },

            ["<C-s>"] = {},
            ["<C-h>"] = {},
            ["<C-t>"] = {},
         },
      },
      dependencies = { { "echasnovski/mini.icons", opts = {} }, },
   },
}
