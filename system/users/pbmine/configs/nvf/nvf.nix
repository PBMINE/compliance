{
  inputs,
  pkgs,
  ...
}: {
  vim = {
    theme = {
      enable = true;
      name = "everforest";
      style = "medium";
      transparent = true;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    presence.cord-nvim.enable = true;

    filetree.neo-tree.enable = true;

    tabline.nvimBufferline.enable = true;

    extraPackages = [
      inputs.qml-language-server.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.luau-lsp
      pkgs.rojo
    ];

    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true;
      servers = {
        qml-language-server = {
          cmd = ["qml-language-server"];
          filetypes = ["qml"];
          root_markers = ["qmldir" "shell.qml" ".git"];
        };
      };
    };

    lazy.plugins = {
      "luau-lsp.nvim" = {
        package = pkgs.vimPlugins.luau-lsp-nvim;
        setupModule = "luau-lsp";
        setupOpts = {
          platform = {
            type = "roblox";
          };
          types = {
            roblox_security_level = "PluginSecurity";
          };
          sourcemap = {
            enabled = true;
            autogenerate = true; # automatic generation when the server is initialized
            rojo_path = "rojo";
            rojo_project_file = "default.project.json";
            include_non_scripts = true;
            sourcemap_file = "sourcemap.json";
          };
        };
        after = "print('Loaded LuaU lsp')";
      };
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      nix.enable = true;
      markdown.enable = true;
      zig.enable = true;
      qml = {
        enable = true;
        lsp.enable = false;
      };
      toml.enable = true;
    };
  };
}
