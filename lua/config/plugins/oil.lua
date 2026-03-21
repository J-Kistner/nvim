return {
   {
      "stevearc/oil.nvim",
      --@module "oil"
      --@type oil.SetupOpts
      opts = {
         watch_for_changes = false,
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
      dependencies = {
         { "echasnovski/mini.icons", opts = {} },
         {
            "malewicz1337/oil-git.nvim",
            dependencies = { "stevearc/oil.nvim" },
            opts = {
               show_file_highlights = true,
               show_directory_highlights = true,
               show_ignored_files = true,
               highlights = {
                  OilGitAdded = { fg = "#bd93f9" },     -- green
                  OilGitModified = { fg = "#E9729D" },  -- yellow
                  OilGitRenamed = { fg = "#cba6f7" },   -- purple
                  OilGitUntracked = { fg = "#89b4fa" }, -- blue
                  OilGitIgnored = { fg = "#6c7086" },   -- gray
               },
            },
         },
      },
   }
}
