# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

Entry point is `init.lua`, which loads four core modules and a small `LoggerError` utility command.

```
init.lua
├── lua/config/lazy.lua       — lazy.nvim bootstrap, mapleader = " ", imports lua/plugins/
├── lua/config/opts.lua       — editor options (indentation, clipboard, etc.)
├── lua/config/keys.lua       — global keymaps and diagnostic/dbee bindings
└── lua/config/lsp.lua        — LSP server configs using vim.lsp.enable() (Neovim 0.11+ API)
```

Plugin declarations live in `lua/plugins/<name>/init.lua` — these are lazy.nvim spec files returned as Lua tables. Plugin *configuration* (setup calls, keymaps) lives in `after/plugin/<name>.lua`, which Neovim loads automatically after plugins are initialized.

**Critical rule:** A plugin spec in `lua/plugins/` should NOT also call `setup()` (via `config = function()` or `opts = {}`), if `after/plugin/` already configures it. Double-setup causes the first call to be silently overwritten.

## Plugin Inventory

| Plugin | Declaration | Configuration |
|---|---|---|
| nvim-tree | `lua/plugins/nvim-tree/` | `after/plugin/nvim-tree.lua` |
| telescope | `lua/plugins/telescope/` | `after/plugin/telescope.lua` |
| treesitter | `lua/plugins/treesitter/` | `after/plugin/treesitter.lua` |
| conform | `lua/plugins/conform/` | `after/plugin/conform.lua` |
| nvim-cmp | `lua/plugins/cmp/` | `after/plugin/nvim-cmp.lua` (SQL only) |
| gitsigns | `lua/plugins/gitsigns/` | inline `config = function()` |
| nvim-dbee | `lua/plugins/nvim-dbee/` | inline `config = function()` |
| buffer-picker | `lua/plugins/buffer-picker/` | `after/plugin/buffer-picker.lua` |
| vim-tmux-navigator | `lua/plugins/vim-tmux-navigator/` | inline |
| mason / mason-lspconfig | `lua/plugins/mason/`, `mason-lspconfig/` | none (lsp handled via vim.lsp.enable) |

## LSP Setup

Uses the Neovim 0.11+ native `vim.lsp.enable()` / `vim.lsp.config()` API — **not** `lspconfig` setup handlers or mason-lspconfig's `handlers`. Servers must be installed separately (via Mason `:MasonInstall` or system packages). Active servers: `ts_ls`, `lua_ls`, `golangci_lint_ls`, `gopls`, `pylsp`, `yamlls`, `sqls`.

## SQL / Database

Two parallel DB tools coexist:
- **nvim-dbee** — interactive DB browser (`<leader>db` to open, `<leader>dr` to run)
- **vim-dadbod + vim-dadbod-completion** — SQL completion in `sql`/`mysql`/`plsql` buffers

Both use hardcoded PostgreSQL connection strings. The `sqls` LSP also connects to PostgreSQL for hover/completion. `vim.g.omni_sql_no_default_maps = 1` in `opts.lua` suppresses the default SQL omnicomplete mappings that conflict with dbext.

## Key Mappings Reference

| Key | Action |
|---|---|
| `<leader>ff` | Telescope find files |
| `<C-p>` | Telescope git files |
| `<leader>ps` | Telescope grep string |
| `<leader>e` | Toggle nvim-tree |
| `<leader>q` | Quickfix with all diagnostics |
| `<leader>ql` | Location list for current buffer |
| `<leader>gb/gd/gp` | Gitsigns blame/diff/preview |
| `<leader>db` | Open nvim-dbee |
| `<leader>dr` | DBee run file or visual selection |
| `<leader>dd` | Delete all lines matching word under cursor |
| `<leader>de` | Insert `logger.error("logger N")` snippet |
| `<C-h/j/k/l>` | Tmux-aware window navigation |

## Formatters

Conform runs on `BufWritePre`. Formatters per filetype: `stylua` (lua), `isort`+`black` (python), `rustfmt` (rust), `prettierd`/`prettier` (js/ts/json/css), `goimports` (go), `pgformatter` (sql). The `pgformatter` binary path is hardcoded to `~/.local/share/nvim/mason/bin/pg_format`.

## Colorscheme

`after/plugin/color.lua` applies `ColorMyPencils()` which sets `evening` colorscheme with transparent Normal/NormalFloat/EndOfBuffer backgrounds.
