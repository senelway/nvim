# nvim

Personal Neovim config. Kickstart-derived, restructured into one file per plugin.

Requires **Neovim 0.12+** (uses `vim.lsp.config`, `vim.lsp.enable`, `vim.diagnostic.jump`,
`vim.fs.joinpath`, and the `main` branch of nvim-treesitter).

## Layout

```
init.lua                 bootstrap lazy.nvim, rtp trimming
lua/config/set.lua       options
lua/config/keymap.lua    global keymaps, leader = <Space>
lua/config/typescript.lua  gd handler that filters react/index.d.ts
lua/tools/yank.lua       highlight on yank
lua/plugins/setup.lua    the plugin manifest — every spec is required from here
lua/plugins/*.lua        one plugin (or cluster) per file
```

A new plugin file is only loaded once it is added to `lua/plugins/setup.lua`.

## External dependencies

| Tool | Used by |
|---|---|
| `git`, `curl` | lazy.nvim, mason |
| `rg` | snacks.picker grep |
| `gh` | snacks.picker `gh_issue` / `gh_pr` |
| `node`, `npm` | typescript-tools, eslint_d, copilot |
| `go` | gopls, delve, neotest-golang (`gotestsum`) |
| `dotnet` | roslyn.nvim, neotest-dotnet |
| `cargo` | rust-analyzer |
| a C compiler | treesitter parser builds |

LSP servers, formatters, linters and debug adapters are installed automatically by
mason-tool-installer — see `ensure_installed` in `lua/plugins/lsp.lua`. Those entries are
**Mason registry package names** (`lua-language-server`), not lspconfig server names
(`lua_ls`); mixing them up fails silently.

## Keymaps

Leader is `<Space>`. Non-obvious ones:

| Key | Action |
|---|---|
| `<leader><space>` | smart find files |
| `<leader>sf` / `sg` / `sw` | files / grep / grep word |
| `<leader>sb` / `sd` / `sr` / `su` | buffers / diagnostics / resume / undo |
| `<leader>e` | file explorer |
| `<leader>i` | floating terminal |
| `<leader>.` | vinote notes |
| `<leader>/` `<leader>?` | toggle line / block comment |
| `<leader>f` | format buffer |
| `<leader>gs` | fugitive status |
| `<leader>g1`…`g4` | GitHub issues / PRs |
| `<leader>g8` `g9` `g0` `g-` `g=` | git branches / log file / diff / status / log |
| `<leader>od` | database UI |
| `<leader>a*` | Claude Code |
| `<leader>d*` | debugger |
| `<leader>t*` | tests, terminal |
| `<leader>x*` | diagnostics / trouble |
| `<leader>h d*` | devdocs |
| `gd` `gD` `gr` | definition / declaration / references |
| `<C-s>` | signature help (**not** `<C-M>` — that is literally `<CR>`) |
| `jk`, `jj` | leave insert / terminal mode |

## Maintenance

```bash
nvim --headless '+Lazy! sync' +qa       # update plugins, rewrites lazy-lock.json
nvim '+checkhealth'
nvim '+Lazy profile'                    # startup cost per plugin
nvim --headless --startuptime /dev/stdout +qa | tail -1
```

`lazy-lock.json` is committed on purpose — it is what makes the config reproducible on
another machine. Commit it after a `Lazy sync`.

Startup is ~22ms. Only six plugins load eagerly (catppuccin, lualine, mini.icons,
nvim-treesitter, snacks, lazy itself); everything else is deferred by `event`, `ft`, `cmd`
or `keys`. Keep it that way — check with `:Lazy profile` after adding a plugin, and note
that listing a plugin under another's `dependencies` forces it eager.

## Not in git

`db_ui/` (database connection strings, **plaintext credentials** — mode 600) and `notes/`
are gitignored deliberately. Do not force-add them.

## Reset

```bash
rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim
```
