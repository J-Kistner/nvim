return {
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = { {
         "nvim-treesitter/playground",
         config = function()
            require "nvim-treesitter.configs".setup {
               playground = {
                  enable = true,
                  disable = {},
                  updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                  persist_queries = false, -- Whether the query persists across vim sessions
                  keybindings = {
                     toggle_query_editor = 'o',
                     toggle_hl_groups = 'i',
                     toggle_injected_languages = 't',
                     toggle_anonymous_nodes = 'a',
                     toggle_language_display = 'I',
                     focus_language = 'f',
                     unfocus_language = 'F',
                     update = 'R',
                     goto_node = '<cr>',
                     show_help = '?',
                  },
               }
            }
         end,
      } },
      config = function()
         require 'nvim-treesitter.configs'.setup {
            -- A list of parser names, or "all" (the listed parsers MUST always be installed)
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust" },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            -- List of parsers to ignore installing (or "all")
            ignore_install = { "javascript" },

            ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
            -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

            highlight = {
               enable = true,

               -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
               -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
               -- the name of the parser)
               -- list of language that will be disabled
               -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
               disable = function(lang, buf)
                  local max_filesize = 100 * 1024 -- 100 KB
                  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                  if ok and stats and stats.size > max_filesize then
                     return true
                  end
               end,

               -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
               -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
               -- Using this option may slow down your editor, and you may see some duplicate highlights.
               -- Instead of true it can also be a list of languages
               additional_vim_regex_highlighting = false,
            },
         }
      end
   },
   {
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
         vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#270f2d" })
         require("treesitter-context").setup {
            enable = true, -- Enable this plugin (Can be toggled later)
            max_lines = 5, -- How many lines the context window can span
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = 'outer',
            mode = 'cursor',
            separator = nil,
         }
      end
   }
}
