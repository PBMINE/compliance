{...}: {
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

    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      nix.enable = true;
      markdown.enable = true;
      zig.enable = true;
      qml.enable = true;
      toml.enable = true;
    };
  };
}
