## MODIFIED Requirements

### Requirement: Parser registration in init.lua
The `setup()` function SHALL register the `openspec_spec` language for the `openspec-spec` filetype using `vim.treesitter.language.register()`. Registration SHALL be guarded so it does not error when the parser `.so` is not available.

#### Scenario: Parser available
- **WHEN** `parser/openspec_spec.so` exists on the runtimepath
- **THEN** `vim.treesitter.language.register("openspec_spec", "openspec-spec")` SHALL succeed
- **AND** opening a spec file SHALL activate tree-sitter highlighting

#### Scenario: Parser not available
- **WHEN** `parser/openspec_spec.so` does NOT exist on the runtimepath
- **THEN** the plugin SHALL NOT error on setup
- **AND** spec files SHALL fall back to plain markdown display
