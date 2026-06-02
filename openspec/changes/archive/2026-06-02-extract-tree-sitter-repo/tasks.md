# Tasks: Extract Tree-sitter Grammar to Dedicated Repo

## Tasks

- [x] Add `tree-sitter-openspec` as flake input
- [x] Include tree-sitter-openspec grammar package in devshell NixVim extraPlugins
- [x] Remove `tree-sitter-openspec-spec/` directory
- [x] Remove `queries/openspec_spec/` directory
- [x] Remove parser compilation from flake.nix shell hook and gcc from buildInputs
- [x] Simplify `init.lua` parser registration
- [x] Update `.gitignore` (remove `parser/` entry)
- [ ] Verify: highlighting works in devshell, parser loads from dependency
