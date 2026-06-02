# Tasks: Add Nix Devshell

## Tasks

- [x] Create `flake.nix` with NixVim module, devShell, and app output
  - NixVim module: extraPlugins (plenary, treesitter.withAllGrammars, neo-tree, web-devicons), extraConfigLua (rtp, openspec setup, reload, test keymap), opts, colorscheme, plugins (lualine, devicons, treesitter, lua_ls)
  - devShell: nvim + lua-language-server + stylua + tree-sitter + nodejs, XDG isolation, OPENSPEC_DEV_PATH, shell banner
  - App output: `nix run` launches the configured nvim
- [x] Add `.dev/` to `.gitignore`
- [ ] Verify: `nix develop` enters shell, `nvim` launches with plugin loaded, `<Space>rr` reloads, highlighting works on openspec spec files, neo-tree shows openspec directory styling
