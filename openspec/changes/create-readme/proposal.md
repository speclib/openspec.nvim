# Create README

**Status**: proposed
**Schema**: spec-driven

## Problem

The repo has no README. Users landing on `github.com/speclib/openspec.nvim` have no idea what this plugin does, how to install it, or what OpenSpec is.

## Solution

Create a README.md following GitHub best practices and neovim plugin conventions.

## Structure

1. **Title + one-liner** — "Neovim plugin for OpenSpec — tree-sitter highlighting, filetype detection, and neo-tree integration"
2. **Features** — brief bullet list of what the plugin provides
3. **Requirements** — neovim 0.9+, tree-sitter-openspec (for highlighting), neo-tree (optional)
4. **Installation**
   - Nix / NixVim — flake input, extraPlugins
   - lazy.nvim — plugin spec with tree-sitter-openspec dependency note
   - Manual / other plugin managers
5. **Setup** — `require("openspec").setup()` with available options
6. **Filetypes** — table of path patterns → filetypes
7. **Related projects** — links to tree-sitter-openspec, OpenSpec format
8. **License**

## Scope

### In scope
- README.md with installation, setup, and feature documentation
- Cover both Nix and non-Nix installation paths
- Explain the tree-sitter-openspec dependency clearly

### Out of scope
- Screenshots (add later when we have a good example)
- Contributing guide
- Changelog
