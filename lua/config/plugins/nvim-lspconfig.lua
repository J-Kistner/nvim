return {
   {
      "neovim/nvim-lspconfig",
      opts = {
         servers = {
            ts_ls = {
               on_attach = function(client, bufnr)
                  -- Optional: Disable tsserver formatting if using prettier or null-ls
                  client.server_capabilities.documentFormattingProvider = false

                  -- Optional: Set keymaps or attach other tools here
                  local bufmap = function(mode, lhs, rhs)
                     vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
                  end

                  bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
                  bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
                  bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
               end,
            },
            tsstandard = {},
            cssls = {
               filetypes = { "css", "scss", "less", "jsx", "tsx" }
            },
            lua_ls = {},
            basedpyright = {
               settings = {
                  basedpyright = {
                     analysis = {
                        autoImportCompletions = true,
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace", -- "openFilesOnly" for performance
                        typeCheckingMode = "strict",  -- options: "off", "basic", "strict"
                        stubPath = "typings",         -- optional: useful for custom type stubs

                        inlayHints = {
                           variableTypes = true,
                           functionReturnTypes = true,
                           parameterNames = true,
                        },
                     },
                  },
               },
            },
            rust_analyzer = {
               -- cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
               formatting = {
                  tabSize = 3,
               },
               settings = {
                  ["rust_analyzer"] = {
                     check = {
                        command = "clippy",
                        features = "all",
                     },
                     imports = {
                        granularity = {
                           group = "module",
                        },
                        prefix = "self",
                     },
                     cargo = {
                        allFeatures = true,
                        buildScripts = {
                           enable = true,
                        },
                     },
                     procMacro = {
                        enable = true,
                     },
                     inlayHints = {
                        variableTypes = true,
                        functionReturnTypes = true,
                        parameterNames = true,
                        bindingModeHints = {
                           enable = true,
                        },
                        implicitDrops = {
                           enable = true,
                        },
                        enable = true,
                        typeHints = {
                           enable = true,
                        },
                     },
                     parameterHints = {
                        enable = true,
                     },
                     completion = {
                        privateEditable = {
                           enable = true,
                        },
                     },
                     diagnostics = {
                        warningsAsInfo = true,
                        styleLints = {
                           enable = true,
                        },
                     },
                     highlightRelated = {
                        exitPoints = { enable = true },
                        references = { enable = true },

                     }
                  },
               },
               ---@diagnostic disable-next-line: unused-local
               on_attach = function(client, bufnr)
                  vim.lsp.inlay_hint.enable(true)
               end
            },
            slint_lsp = {},
            jsonls = {
               settings = {
                  json = {
                     validate = { enable = true },
                  },
               },
            },
         }
      },
      config = function(_, opts)
         -- For inline error messages
         vim.diagnostic.config({
            virtual_text = true, -- show inline text
            signs = true,        -- show signs in gutter
            underline = true,    -- underline errors
            update_in_insert = false,
            severity_sort = true,
         })

         -- Lsp Key Maps
         local l = vim.lsp.buf
         Key("n", "<leader>h", function() l.hover({ border = "rounded" }) end, "( Lsp ) Show Hover")
         Key("n", "<leader>gd", l.definition, "( Lsp ) Go to Definition")
         Key("n", "<leader>gi", l.implementation, "( Lsp ) Go to Implementation")
         Key("n", "<leader>fr", l.references, "( Lsp ) Find Refrences")
         Key("n", "<leader>rn", l.rename, "( Lsp ) Rename")
         Key("n", "<leader>gD", l.declaration, "( Lsp ) Go to Declaration")
         Key("n", "<leader>ca", l.code_action, "( Lsp ) List codeations")
         Key("n", "<leader>q", function()
            vim.diagnostic.setqflist()
            vim.cmd("cope")
         end, "( Lsp ) Puts all of the error into a quickfix list.")

         vim.api.nvim_create_augroup("nvim-lspconfig", { clear = true })

         -- Auto formatting on write with lsp
         vim.api.nvim_create_autocmd("LspAttach", {
            group = "nvim-lspconfig",
            callback = function(args)
               -- Get the current lsp client
               local client = vim.lsp.get_client_by_id(args.data.client_id)
               if not client then return end
               -- Checking if there is an lsp for the language
               -- The next line was made using "gra"
               ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
               if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_create_autocmd("BufWritePre", { -- Autocmd: When atempting to write stack( this, write )
                     buffer = args.buf,                        -- args.buf: source of current buffer
                     callback = function()
                        -- Formats the current buffer, using the current lsp
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                     end
                  })
               end
            end,
         })

         vim.api.nvim_create_user_command("LspPermaStop", function()
            vim.cmd("LspStop")

            vim.api.nvim_del_autocmd(
               vim.api.nvim_get_autocmds({ group = "nvim-lspconfig" })[1].id
            )
         end, {})

         local lspconfig = require("lspconfig")

         vim.api.nvim_create_autocmd("BufEnter", {
            group = "nvim-lspconfig",
            callback = function()
               vim.lsp.inlay_hint.enable(true)
            end,
         })

         vim.g.lazydev_enabled = true

         -- Configing lsps to use blink
         for server, config in pairs(opts.servers) do
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
            vim.diagnostic.enable(true)
         end
      end
   },
}
