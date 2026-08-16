return {
   {
      "undont/differ.nvim",
      build = "make go-build",
      cmd = { "Differ" },
      keys = {
         { "<leader>Gd", "<cmd>Differ<CR>", desc = "( Differ ) Diff current file vs worktree" },
         { "<leader>Gh", "<cmd>Differ log<CR>", desc = "( Differ ) File history" },
         { "<leader>Gr", "<cmd>Differ log origin/HEAD...HEAD<CR>", desc = "( Differ ) PR range diff" },
      },
      config = function()
         require("differ").setup({
            keymaps = {
               next_file = "<C-j>",
               prev_file = "<C-k>",
            },
         })

         local LIGHT = {
            line_add = "#e6ffec",
            line_del = "#ffebe9",
            word_add = "#abf2bc",
            word_del = "#ffd7d5",
            cursor_add = "#c2f0cc",
            cursor_del = "#ffd9d6",
            staged_add = "#f1fff5",
            staged_del = "#fff6f5",
            staged_word_add = "#c9f3d3",
            staged_word_del = "#ffdfdc",
            green = "#1a7f37",
            red = "#cf222e",
            yellow = "#9a6700",
            blue = "#0969da",
            orange = "#bc4c00",
         }
         local DARK = {
            line_add = "#12281c",
            line_del = "#26191a",
            word_add = "#214f33",
            word_del = "#4c1a16",
            cursor_add = "#1a3d27",
            cursor_del = "#3a1f1c",
            staged_add = "#0c1f15",
            staged_del = "#1c1314",
            staged_word_add = "#173c27",
            staged_word_del = "#3a201d",
            green = "#3fb950",
            red = "#f85149",
            yellow = "#d29922",
            blue = "#58a6ff",
            orange = "#db6d28",
         }

         local function github_colors()
            local c = vim.o.background == "light" and LIGHT or DARK
            local groups = {
               differLineAdd = { bg = c.line_add },
               differLineDelete = { bg = c.line_del },
               differWordAdd = { bg = c.word_add },
               differWordDelete = { bg = c.word_del },
               differCursorLineAdd = { bg = c.cursor_add },
               differCursorLineDelete = { bg = c.cursor_del },
               differStagedLineAdd = { bg = c.staged_add },
               differStagedLineDelete = { bg = c.staged_del },
               differStagedWordAdd = { bg = c.staged_word_add },
               differStagedWordDelete = { bg = c.staged_word_del },
               differPanelAdd = { fg = c.green },
               differPanelModify = { fg = c.yellow },
               differPanelDelete = { fg = c.red },
               differPanelRename = { fg = c.blue },
               differPanelUnmerged = { fg = c.orange },
               differPanelUntracked = { fg = c.green },
               differPanelCountAdd = { fg = c.green },
               differPanelCountDelete = { fg = c.red },
               differStagedSign = { fg = c.green },
            }
            for name, val in pairs(groups) do
               vim.api.nvim_set_hl(0, name, val)
            end
         end

         github_colors()
         vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("differ.github", { clear = true }),
            callback = github_colors,
         })
      end,
   },
}
