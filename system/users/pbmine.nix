{ lib, config, pkgs, ... }: 
{
  home.username = "pbmine";
  home.homeDirectory = "/home/pbmine";
  home.stateVersion = "26.11";
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
  programs.git = {
    enable = true;
  };

  wayland.windowManager.niri.enable = true;
  services.awww.enable = true;
  programs.vesktop.enable = true;
  programs.prismlauncher.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.alacritty.enable = true;
  programs.fuzzel.enable = true;
}

