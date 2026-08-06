# My Nvim Config

A Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim), partially inspired by Advent of Neovim.

## Directory Structure

```
nvim/
├── init.lua                  # Entry point; defines Key() and LspKey() helpers
├── lazy-lock.json            # Plugin lockfile
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # lazy.nvim bootstrap & setup
│   │   ├── plugins/          # One file per plugin / plugin group
│   │   ├── Telescope/
│   │   │   └── live_grep.lua # Custom multi-grep with ripgrep
│   │   ├── Oil/              # Terminal integration inside Oil
│   │   └── TSTools/          # Treesitter utility library
│   └── mconfig/              # Manual (non-lazy) config
│       ├── init.lua          # Loads all mconfig modules
│       ├── opt.lua           # Core vim options
│       ├── remaps.lua        # Keybindings
│       ├── user_commands.lua # Custom :W, :Just commands
│       ├── user_settings.lua # Configurable settings
│       ├── snake_write.lua   # Snake-case writing mode
│       ├── wrap.lua          # Treesitter node wrapping
│       ├── auto_commit.lua   # Auto-committer agent (disabled)
│       ├── flashcards.lua    # Stub (incomplete)
│       └── plugin.lua        # LiveShare auto-write (disabled)
```

- `lua/config/plugins/` — Plugin specs for lazy.nvim
- `lua/mconfig/` — Hand-written settings, keymaps, and utilities

## Plugins

| Plugin | Description |
|--------|-------------|
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine |
| [color-picker.nvim](https://github.com/ziontee113/color-picker.nvim) | GUI color picker |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Git diff viewer |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP status spinner |
| [firenvim](https://github.com/glacambre/firenvim) | Use Nvim in browser text fields |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Pre-built snippet collection |
| [golf](https://github.com/ThePrimeagen/golf) | Vim Golf |
| [harpoon](https://github.com/ThePrimeagen/harpoon) (harpoon2) | Fast file bookmarking |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua LSP enhancements for Nvim config |
| [leetcode.nvim](https://github.com/kawre/leetcode.nvim) | LeetCode in Nvim |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/linter installer |
| [mini.icons](https://github.com/echasnovski/mini.icons) | Filetype icons |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library |
| [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) | Hex color highlighting |
| [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) | Java LSP (Eclipse JDT LS) |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax parsing & highlighting |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Show context above code |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Buffer-based file explorer |
| [oil-git.nvim](https://github.com/stevearc/oil-git.nvim) | Git status in Oil |
| [opencode.nvim](https://github.com/anomalyco/opencode) | AI coding assistant |
| [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) | Code refactoring |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown preview |
| [scrollEOF.nvim](https://github.com/rachartier/scrollEOF.nvim) | Smooth EOF scrolling |
| [shadotheme](https://github.com/shadotheme/shadotheme) | Colorscheme |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [text-case.nvim](https://github.com/johmsalas/text-case.nvim) | Case manipulation |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history |
| [vim-be-good](https://github.com/ThePrimeagen/vim-be-good) | Vim training game |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration |
| [vim-just](https://github.com/NoahTheDuke/vim-just) | Justfile syntax |
| [vim-surround](https://github.com/tpope/vim-surround) | Surround editing |

## Features

### LSP & Completion
- Language servers: TypeScript, CSS, Lua, Python, Rust, Slint, JSON, Java
- `blink.cmp` with LSP, path, snippet, and buffer sources
- Auto-formatting on save
- Inlay hints
- Mason for LSP/linter/formatter management

### File Navigation
- **Harpoon2**: 4 quick slots (`<C-h/t/n/s>`), toggle menu with `<C-e>`
- **Oil.nvim**: Buffer-based file explorer (`<leader>ft`)
- **Telescope**: File find, live grep, help tags, git files/branches
- **Custom live grep**: Supports `pattern  glob` syntax

### Git
- `vim-fugitive` with mnemonic `<leader>G*` mappings
- `diffview.nvim` for diffs
- Oil-git for file status in Oil

### Code Manipulation
- Refactoring (extract function/variable, inline, etc.) via `<leader>r*`
- Text case conversion via `<leader>ga`
- Treesitter node wrapping `Some()/Ok()/Err()` via `<leader>ws/wo/we`
- Snake-case writing mode (`s` in normal mode)

### AI
- OpenCode AI assistant (`<leader>oa/oA`, `<C-.>` toggle)
- Supermaven (installed but disabled by default)

### Java
- nvim-jdtls with organize imports, extract variable/constant/method

### Utilities
- Undotree visual history (`<leader>u`)
- LeetCode integration
- Firenvim browser extension support
- Markdown rendering
- Color picker
- Git/typing games (vim-be-good, golf)
- `:Just` command — pick and run justfile recipes via Telescope

## Key Mappings

Leader key: `<Space>`

### LSP
| Keys | Action |
|------|--------|
| `<leader>h` | Hover doc |
| `<leader>gd` | Go to definition |
| `<leader>gi` | Go to implementation |
| `<leader>fr` | Find references |
| `<leader>rn` | Rename |
| `<leader>ca` | Code actions |
| `<leader>fo` | Format |

### Navigation
| Keys | Action |
|------|--------|
| `<leader>ff` | Find files |
| `<C-g>` | Live grep |
| `<leader>ft` | Open Oil |
| `<C-e>` | Harpoon menu |
| `<C-h/t/n/s>` | Harpoon slots 1-4 |

### Git
| Keys | Action |
|------|--------|
| `<leader>GG` | Git menu |
| `<leader>Gc` | Commit |
| `<leader>Gp` | Push |
| `<leader>GP` | Pull |
| `<leader>Ga` | Add all |

### Other
| Keys | Action |
|------|--------|
| `<leader>s` | Replace word under cursor |
| `<leader>u` | Toggle undotree |
| `<leader>d` | Black-hole delete |
| `<leader>y` | Yank to system clipboard |
| `<F8>` | Insert `\` |
| `gco` | Add range to OpenCode |
