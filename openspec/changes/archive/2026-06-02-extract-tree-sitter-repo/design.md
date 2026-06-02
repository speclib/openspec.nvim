## Context

The tree-sitter grammar for openspec spec files is being extracted to a dedicated repo (`speclib/tree-sitter-openspec`). This change removes the embedded grammar, queries, and parser compilation from openspec.nvim, replacing them with a flake input dependency on tree-sitter-openspec.

## Goals / Non-Goals

**Goals:**
- Remove all tree-sitter grammar source code from this repo
- Consume the pre-built parser and queries from tree-sitter-openspec via Nix flake input
- Simplify `init.lua` parser registration — no more guarded API calls or missing-parser checks
- Devshell still provides working syntax highlighting

**Non-Goals:**
- Changes to filetype detection, neo-tree integration, or plugin setup API
- Supporting non-Nix installation of the grammar (users without Nix can `:TSInstall` from tree-sitter-openspec directly)

## Decisions

### Consume tree-sitter-openspec as flake input

```nix
inputs.tree-sitter-openspec = {
  url = "github:speclib/tree-sitter-openspec";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

The tree-sitter-openspec flake exports a grammar package containing `parser/openspec_spec.so` and `queries/openspec_spec/`. openspec.nvim's flake is responsible for placing this on neovim's runtimepath (via `extraPlugins` in the NixVim module).

### Simplify init.lua parser registration

With the parser `.so` available on the runtimepath (from tree-sitter-openspec), `init.lua` only needs:

```lua
vim.treesitter.language.register("openspec_spec", "openspec-spec")
```

No more:
- `nvim_get_runtime_file` guard checking for the `.so`
- `nvim-treesitter.parsers.get_parser_configs()` fallback
- `install_info` pointing at a local `tree-sitter-openspec-spec/` directory

The guard is still useful for graceful degradation when the grammar package isn't installed (e.g. non-Nix users who haven't run `:TSInstall`), but it's a simple pcall now.

### Remove embedded grammar artifacts

These directories are deleted entirely:
- `tree-sitter-openspec-spec/` (grammar source, generated parser, package.json)
- `queries/openspec_spec/` (highlights.scm, injections.scm)

These are removed from the flake:
- `gcc` from buildInputs
- Parser compilation from shellHook
- `parser/` from `.gitignore`

## Risks / Trade-offs

- **[Dependency coupling]** openspec.nvim now depends on tree-sitter-openspec being available. If the grammar flake is broken, the plugin loses highlighting. → Mitigation: Pin the flake input to a known-good rev. The plugin degrades gracefully — it works without highlighting.

- **[Non-Nix users]** Users who don't use Nix need to install tree-sitter-openspec separately (via `:TSInstall` or manual compilation). → Mitigation: Document installation options. The `install_info` registration can be kept as a fallback pointing at the GitHub repo URL.
