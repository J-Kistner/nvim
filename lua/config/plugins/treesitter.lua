local parsers = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "just" }

return {
    {
       "nvim-treesitter/nvim-treesitter",
       build = ":TSUpdate",
       dependencies = {
          "nvim-treesitter/nvim-treesitter-context"
       },
       config = function()
          local ts = require("nvim-treesitter")

          ts.setup {}

          -- Ensure curated parsers are installed
          for _, lang in ipairs(parsers) do
             if not vim.tbl_contains(ts.get_installed(), lang) then
                ts.install(lang)
             end
          end

          -- Automatically install missing parsers when opening a buffer
          vim.api.nvim_create_autocmd("FileType", {
             callback = function(args)
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if lang and not vim.treesitter.language.add(lang) then
                   vim.schedule(function()
                      if vim.treesitter.language.add(lang) == false then
                         vim.cmd("TSInstall " .. lang)
                      end
                   end)
                end
             end,
          })
       end,
    },
    {
       "nvim-treesitter/nvim-treesitter-context",
       config = function()
          vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#32033f" })
          require("treesitter-context").setup {
             enable = true, -- Enable this plugin (Can be toggled later)
             max_lines = 5, -- How many lines the context window can span
             min_window_height = 0,
             line_numbers = true,
             multiline_threshold = 20,
             trim_scope = 'outer',
             mode = 'cursor',
             separator = nil,
             -- Disable context for markdown files to avoid treesitter issues with injections
             disable = function(lang, bufnr)
                if lang == "markdown" or lang == "markdown_inline" then
                   return true
                end
             end,
          }
       end
    },
}
