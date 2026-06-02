{
  description = "Isolated NixVim environment for openspec.nvim development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      openspecPluginPath = self;

      nixvimModule = {
        extraPlugins = [
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          pkgs.vimPlugins.neo-tree-nvim
          pkgs.vimPlugins.nvim-web-devicons
          pkgs.vimPlugins.nui-nvim
        ];

        extraConfigLua = ''
          -- Add openspec.nvim source to runtimepath
          local openspec_dev_path = vim.fn.getenv("OPENSPEC_DEV_PATH")
          if openspec_dev_path and openspec_dev_path ~= vim.NIL then
            vim.opt.runtimepath:prepend(openspec_dev_path)
          else
            vim.opt.runtimepath:prepend("${openspecPluginPath}")
          end

          vim.g.mapleader = " "

          -- Setup openspec plugin
          require("openspec").setup({
            neotree = true,
          })

          -- Quick reload function for development
          _G.reload_openspec = function()
            for name, _ in pairs(package.loaded) do
              if name:match("^openspec") then
                package.loaded[name] = nil
              end
            end
            require("openspec").setup({
              neotree = true,
            })
            local path = vim.fn.getenv("OPENSPEC_DEV_PATH") or "${openspecPluginPath}"
            print("openspec.nvim reloaded from: " .. path)
          end

          vim.keymap.set("n", "<leader>rr", reload_openspec, { desc = "Reload openspec.nvim" })

          -- Run plenary tests
          vim.keymap.set("n", "<leader>rt", function()
            vim.cmd("PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}")
          end, { desc = "Run tests" })
        '';

        opts = {
          number = true;
          relativenumber = true;
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          signcolumn = "yes";
          termguicolors = true;
        };

        colorschemes.gruvbox.enable = true;

        plugins = {
          lualine.enable = true;
          web-devicons.enable = true;
          treesitter.enable = true;

          lsp = {
            enable = true;
            servers = {
              lua_ls = {
                enable = true;
                settings = {
                  Lua = {
                    diagnostics = {
                      globals = [ "vim" "describe" "it" "before_each" "after_each" ];
                    };
                    workspace = {
                      library = [
                        "\${3rd}/luv/library"
                      ];
                      checkThirdParty = false;
                    };
                  };
                };
              };
            };
          };
        };
      };

      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = nixvimModule;
      };

    in
    {
      packages.${system} = {
        default = nvim;
        neovim = nvim;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          nvim
          pkgs.lua-language-server
          pkgs.stylua
          pkgs.tree-sitter
          pkgs.nodejs
          pkgs.gcc
        ];

        shellHook = ''
          echo ""
          echo "  openspec.nvim Development Environment"
          echo ""
          echo " Plugin source: $(pwd) (live reload enabled)"
          echo ""
          echo " Commands:"
          echo "   nvim                    - Start Neovim"
          echo "   tree-sitter generate    - Regenerate parser from grammar.js"
          echo "   tree-sitter test        - Run grammar tests"
          echo ""
          echo " Keymaps (inside Neovim):"
          echo "   <Space>rr  - Reload openspec.nvim (clears Lua cache)"
          echo "   <Space>rt  - Run plenary tests"
          echo ""

          export OPENSPEC_DEV_PATH="$(pwd)"

          export XDG_CONFIG_HOME="$(pwd)/.dev/config"
          export XDG_DATA_HOME="$(pwd)/.dev/share"
          export XDG_STATE_HOME="$(pwd)/.dev/state"
          export XDG_CACHE_HOME="$(pwd)/.dev/cache"

          mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"

          # Compile the custom openspec_spec tree-sitter parser
          PARSER_DIR="$(pwd)/parser"
          PARSER_SO="$PARSER_DIR/openspec_spec.so"
          PARSER_SRC="$(pwd)/tree-sitter-openspec-spec/src/parser.c"
          if [ ! -f "$PARSER_SO" ] || [ "$PARSER_SRC" -nt "$PARSER_SO" ]; then
            mkdir -p "$PARSER_DIR"
            echo " Compiling openspec_spec parser..."
            gcc -o "$PARSER_SO" -shared -fPIC -I "$(pwd)/tree-sitter-openspec-spec/src" "$PARSER_SRC" -Os
            echo " Parser compiled: $PARSER_SO"
          fi
        '';
      };

      apps.${system}.default = {
        type = "app";
        program = "${nvim}/bin/nvim";
      };
    };
}
