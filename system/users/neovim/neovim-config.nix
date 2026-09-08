{
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

    formatter.conform-nvim.presets.nixfmt-rs.enable = true;

    lsp.enable = true;
    languages = {
      enableTreesitter = true;

      nix.enable = true;
    };
  };
}
