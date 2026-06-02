# Extract Tree-sitter Grammar to Dedicated Repo

**Status**: proposed
**Schema**: spec-driven

## Problem

The tree-sitter grammar for openspec spec files is embedded inside openspec.nvim. This makes it hard to:
- Use the grammar outside of neovim (other editors, CI tooling)
- Build and distribute the compiled parser via Nix
- Add future grammars for other openspec artifact types (proposal, design, tasks)
- Follow the tree-sitter ecosystem convention of standalone grammar repos

The current setup also has a fragile parser compilation step in the devshell hook and a guard in `init.lua` to avoid registering a parser that doesn't exist as a `.so`.

## Solution

Extract the grammar, queries, and tests to a new dedicated repo at `github:speclib/tree-sitter-openspec`. Structure it as a multi-grammar repo (following the tree-sitter-xml pattern) so future grammars can be added as siblings.

Then make openspec.nvim depend on tree-sitter-openspec as a flake input, consuming its pre-built neovim plugin output.

## Scope

### In scope (this change — openspec.nvim side)
- Remove `tree-sitter-openspec-spec/` directory
- Remove `queries/openspec_spec/` directory
- Remove `parser/` compilation from flake.nix shell hook
- Add `tree-sitter-openspec` as flake input
- Include tree-sitter-openspec's neovim-plugin output in extraPlugins
- Simplify `init.lua` parser registration (the parser .so comes from the dependency)
- Update `.gitignore` (remove `parser/` entry)

### Out of scope
- Adding new grammars (future work in tree-sitter-openspec)
- The tree-sitter-openspec repo setup (tracked separately in that repo)

## Approach

1. Wait for tree-sitter-openspec to be set up and working
2. Add it as a flake input in openspec.nvim
3. Remove embedded grammar code, queries, and parser compilation
4. Simplify init.lua — the parser arrives pre-compiled on the rtp
5. Verify in devshell: highlighting still works, `:TSInstall` not needed
