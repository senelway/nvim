# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on kickstart.nvim, using Lazy.nvim as the plugin manager. The configuration is written in Lua and follows a modular structure with organized plugin configurations.

## Project Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point, bootstraps lazy.nvim
├── lua/
│   ├── config/             # Core Neovim settings
│   │   ├── set.lua         # Vim options (line numbers, clipboard, etc.)
│   │   ├── keymap.lua      # Global keybindings
│   │   └── typescript.lua  # TypeScript LSP helpers (filters react/index.d.ts)
│   ├── plugins/            # Plugin configurations (each returns lazy.nvim spec)
│   │   ├── setup.lua       # Plugin load order
│   │   ├── lsp.lua         # LSP configuration with Mason
│   │   ├── cmp.lua         # Blink.cmp completion
│   │   ├── treesitter.lua  # Syntax highlighting
│   │   ├── snacks.lua      # Snacks.nvim (picker, terminal, explorer)
│   │   ├── claude.lua      # Claude Code integration
│   │   ├── spoo.lua        # Spotify control via AppleScript
│   │   └── ...             # Other plugins
│   └── tools/
│       └── yank.lua        # Highlight yanked text
└── lazy-lock.json          # Locked plugin versions
```

## Configuration Philosophy

- **Modular Design**: Each plugin has its own file in `lua/plugins/`, returning a lazy.nvim plugin spec
- **Load Order**: Plugin loading is controlled via `lua/plugins/setup.lua`
- **Lazy Loading**: Most plugins use lazy loading via event triggers (`VeryLazy`, `BufReadPre`, etc.)
- **Performance**: Disabled several built-in Vim plugins in `init.lua` for faster startup

## Key Components

### Plugin Manager (Lazy.nvim)

Lazy.nvim is bootstrapped in `init.lua`. All plugin specs are loaded from `require 'plugins.setup'`.

### LSP Configuration (lua/plugins/lsp.lua)

- Uses **Mason** for managing LSP servers, formatters, linters, and DAPs
- Configured servers: `lua_ls`, `cssls`, and others installed via `ensure_installed`
- Tools installed: gopls, rust_analyzer, css-lsp, html-lsp, eslint-lsp, tailwindcss, svelte, omnisharp
- LSP keybindings are set up in the `LspAttach` autocommand
- Integrates with Blink.cmp for capabilities

### Completion (lua/plugins/cmp.lua)

Uses **Blink.cmp** with LuaSnip for snippets. Includes:
- LSP completion
- Path completion
- Snippets (LuaSnip)
- Lazydev integration for Neovim API completion
- Dadbod integration for SQL completion

### File Navigation & Search (lua/plugins/snacks.lua)

Uses **Snacks.nvim** for:
- File picker (`<leader><space>`, `<leader>sf`)
- Grep search (`<leader>sg`, `<leader>sw`)
- Buffer management (`<leader>sb`, `<leader>bd`)
- File explorer (`<leader>e`)
- Floating terminal (`<leader>i`)
- Git integration (branches, log, status, diff)
- GitHub integration (issues, PRs)
- Scratch buffers (`<leader>.`)

### Harpoon (lua/plugins/harpoon.lua)

Quick file navigation:
- `<leader>a`: Add file to Harpoon
- `<leader>sm`: Toggle Harpoon menu
- `<C-n>`, `<C-p>`: Navigate between Harpoon files

### Custom Tools

#### TypeScript Helper (lua/config/typescript.lua)

Custom `on_list` function that filters out `react/index.d.ts` from LSP definition results to avoid jumping to React types when using `gd`.

#### Spotify Control (lua/plugins/spoo.lua)

Controls Spotify on macOS via AppleScript:
- `<leader>mo`: Open Spotify control menu with play/pause, next/previous, volume, and copy track URL

### Claude Code Integration (lua/plugins/claude.lua)

- `<leader>ac`: Toggle Claude Code
- `<leader>ab`: Add current buffer
- `<leader>as`: Send selection to Claude (visual mode)
- `<leader>aa`: Accept diff
- `<leader>ad`: Deny diff
- Diff opens in horizontal split by default

## Development Workflow

### Testing

Configured via **neotest** (`lua/plugins/tests.lua`) with support for:
- Go (neotest-golang with gotestsum)
- Vitest (JavaScript/TypeScript)
- .NET (neotest-dotnet)

### Formatting

Auto-formatting on save via **conform.nvim** (`lua/plugins/conform.lua`):
- Manual format: `<leader>f`
- Configured formatters: stylua, goimports, gofumpt, eslint_d

### Linting

Linting via **nvim-lint** (`lua/plugins/lint.lua`):
- JSON: jsonlint
- HTML: htmlhint
- YAML: yamllint
- Go: golangci-lint

### Diagnostics

- `[d`, `]d`: Navigate diagnostics with auto-open float
- `<leader>oe`: Open floating diagnostic
- `<leader>x`: Open diagnostics in location list

## Important Keybindings

### Global

- Leader: `<Space>`
- Exit insert/terminal: `jk` or `jj`
- Window navigation: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`

### LSP

- `gd`: Go to definition (with TypeScript filter)
- `gD`: Go to declaration
- `gr`: LSP references (via Snacks picker)
- `<leader>rn`: Rename
- `<leader>ca`: Code action
- `<C-M>`: Signature help
- `<leader>th`: Toggle inlay hints

### Git

- `<leader>gg`: Git command
- `<leader>gm`: Git mergetool
- `<leader>g-`: Git status (picker)
- `<leader>g0`: Git branches/diff
- `<leader>g=`: Git log
- `<leader>go`: Open file/selection in GitHub

### File Management

- `<leader>e`: File explorer
- `<leader><space>`: Smart file finder
- `<leader>sf`: Find files
- `<leader>sg`: Grep
- `<leader>sb`: Buffers
- `<leader>bd`: Delete buffer
- `<leader>bw`: Wipe buffer

### Quickfix

- `]q`, `[q`: Navigate quickfix list

## Reset Configuration

To reset Neovim's state (clear cache and data):

```bash
rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim
```

## Notes

- Configuration uses Nerd Fonts for icons
- Clipboard is synced with OS clipboard
- Relative line numbers enabled
- No swap files or backup files
- Tab width: 2 spaces
- Diagnostic signs use Nerd Font icons when available
