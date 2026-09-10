{
  inputs,
  pkgs,
  ...
}: {
  vim = {
    theme = {
      enable = true;
      name = "everforest";
      style = "soft";
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    presence.cord-nvim.enable = true;

    extraPackages = [
      inputs.qml-language-server.packages.${pkgs.stdenv.hostPlatform.system}.default
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
