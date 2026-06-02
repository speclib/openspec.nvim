## ADDED Requirements

### Requirement: Grammar consumed via flake input
The openspec.nvim flake SHALL declare `tree-sitter-openspec` as a flake input and include its grammar package output in the devshell's NixVim `extraPlugins`, placing the compiled parser and queries on neovim's runtimepath.

#### Scenario: Devshell includes grammar
- **WHEN** `nix develop` is entered in the openspec.nvim repo
- **THEN** neovim SHALL have `parser/openspec_spec.so` available on the runtimepath
- **AND** neovim SHALL have `queries/openspec_spec/highlights.scm` available on the runtimepath

### Requirement: No embedded grammar source
The openspec.nvim repo SHALL NOT contain tree-sitter grammar source code, generated parser files, or query files — these belong to tree-sitter-openspec.

#### Scenario: Directories removed
- **WHEN** the extraction is complete
- **THEN** `tree-sitter-openspec-spec/` SHALL NOT exist in the repo
- **AND** `queries/openspec_spec/` SHALL NOT exist in the repo

## REMOVED Requirements

### Requirement: Parser compilation in shell hook
The flake.nix shell hook SHALL NOT compile tree-sitter parsers — the pre-built `.so` comes from the tree-sitter-openspec dependency.

#### Scenario: No gcc in devshell
- **WHEN** `nix develop` is entered
- **THEN** `gcc` SHALL NOT be a required buildInput for the devshell
