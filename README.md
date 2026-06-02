# openspec.nvim

Neovim plugin for [OpenSpec](https://github.com/speclib) files — tree-sitter syntax highlighting, filetype detection, and neo-tree integration.

## Features

- **Tree-sitter highlighting** for spec files — requirements, scenarios, normative keywords (SHALL, MUST), conditions (WHEN/THEN/AND), and delta sections
- **Filetype detection** for all OpenSpec artifact types based on path patterns
- **Neo-tree integration** — archive folder styling with distinct icon and muted text (optional)
- **Markdown injection** — inline markdown formatting (bold, code, links) works inside spec prose

## Requirements

- Neovim >= 0.9
- [tree-sitter-openspec](https://github.com/speclib/tree-sitter-openspec) — provides the compiled parser and highlight queries
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) (optional) — for archive folder styling

## Installation

### Nix / NixVim

Add both `openspec.nvim` and `tree-sitter-openspec` as flake inputs:

```nix
inputs = {
  openspec-nvim.url = "github:speclib/openspec.nvim";
  tree-sitter-openspec.url = "github:speclib/tree-sitter-openspec";
};
```

Then add them to your NixVim `extraPlugins`:

```nix
extraPlugins = [
  inputs.openspec-nvim.packages.${system}.default
  inputs.tree-sitter-openspec.packages.${system}.default
];
```

And call setup in `extraConfigLua`:

```lua
require("openspec").setup({
  neotree = true, -- set to false if you don't use neo-tree
})
```

### lazy.nvim

```lua
{
  "speclib/openspec.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("openspec").setup({
      neotree = false,
    })
  end,
}
```

> **Note:** You also need the `openspec_spec` tree-sitter parser. Install [tree-sitter-openspec](https://github.com/speclib/tree-sitter-openspec) and run `:TSInstall openspec_spec`, or build it manually.

## Setup

```lua
require("openspec").setup({
  neotree = false, -- enable neo-tree archive folder styling
})
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `neotree` | boolean | `false` | Enable neo-tree component overrides for archive folder |

## Filetypes

Files under an `openspec/` directory are automatically assigned filetypes:

| Pattern | Filetype |
|---------|----------|
| `**/openspec/**/spec.md` | `openspec-spec` |
| `**/openspec/**/proposal.md` | `openspec-proposal` |
| `**/openspec/**/design.md` | `openspec-design` |
| `**/openspec/**/tasks.md` | `openspec-tasks` |

Only `openspec-spec` has tree-sitter highlighting via the custom grammar. Other filetypes fall back to markdown.

## Related Projects

- [tree-sitter-openspec](https://github.com/speclib/tree-sitter-openspec) — tree-sitter grammars for OpenSpec files
- [openspec](https://github.com/speclib/openspec) — the OpenSpec specification format

## License

MIT
