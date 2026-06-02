# Add Nix Devshell

**Status**: proposed
**Schema**: spec-driven

## Problem

openspec.nvim has no isolated development environment. Developing the plugin — especially iterating on the tree-sitter grammar, testing highlighting, and verifying neo-tree integration — requires manually configuring neovim. There's no reproducible setup for contributors.

## Solution

Add a `flake.nix` that provides an isolated NixVim-based development shell, adapted from [vim-mimosa's devshell](~/cVibeCoding/vim-mimosa/flake.nix).

The devshell provides:
- A NixVim-built neovim with the plugin on the runtimepath
- `require("openspec").setup({ neotree = true })` pre-configured
- XDG directory isolation (`.dev/`) so it doesn't touch the user's main neovim config
- `OPENSPEC_DEV_PATH` env var for live source reloading
- Lua cache-clearing reload function (`<Space>rr`)
- Plenary test runner keymap (`<Space>rt`)
- lua_ls + stylua for Lua development
- Treesitter with all grammars + the custom `openspec_spec` parser compiled from local source
- Neo-tree available for testing the integration
- `tree-sitter` CLI for grammar development (`tree-sitter generate`, `tree-sitter test`)

## Scope

### In scope
- `flake.nix` with NixVim devshell
- XDG isolation via `.dev/` directory
- Live reload support (Lua modules matching `^openspec`)
- Custom tree-sitter grammar compilation and installation into the dev neovim
- `tree-sitter` CLI in the devshell for grammar iteration
- Neo-tree plugin included for integration testing
- lua_ls configured with vim/plenary globals
- Plenary-based test runner keymap
- `.gitignore` entry for `.dev/`

### Out of scope
- Writing tests (separate concern)
- CI/CD integration
- Multi-architecture support (x86_64-linux only for now)
- Grammar reload keymap (restart nvim after grammar changes)

## Approach

Adapt vim-mimosa's `flake.nix` with openspec-specific paths and setup. Key adaptations:
1. Replace `MIMOSA_DEV_PATH` with `OPENSPEC_DEV_PATH`, reload clears `^openspec` modules
2. Add `require("openspec").setup({ neotree = true })` to extraConfigLua
3. Include neo-tree in extraPlugins
4. Include `tree-sitter` CLI and `nodejs` in devShell buildInputs for grammar development
5. Compile the custom `openspec_spec` parser from `tree-sitter-openspec-spec/` and register it — the plugin's `init.lua` already handles registration via `nvim-treesitter.parsers`, so the devshell just needs the source on the rtp
