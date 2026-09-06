{ pkgs, lib, ... }:
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

    lsp.enable = true;
    languages = {
      enableTreesitter = true;

      nix.enable = true;
    };
  };  
}
