{
  pkgs,
  inputs,
  config,
  ...
}: {
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

  # A packages that doesnt required for home to manage it
  home.packages = with pkgs; [
    pwvucontrol
    pfetch-rs
    nautilus
  ];

  # A Window Manager
  wayland.windowManager.niri.enable = true;

  # A wallpaper services
  services.awww.enable = true;

  # Temp lock-screen services (To be replace with quickshell)
  programs.swaylock.enable = true;

  # Enable OBS for recording!
  programs.obs-studio.enable = true;

  programs.nvf = {
    enable = true;
    # Import the settings instead of writing down here!
    settings = import ./configs/neovim/neovim-config.nix;
  };

  # Enable quickshell
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # a bunch of programs for user
  programs.git.enable = true;
  programs.vesktop.enable = true;
  programs.prismlauncher.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.alacritty.enable = true;
  programs.fuzzel.enable = true;
  xdg.configFile = import ./configs/listing.nix {inherit config;};
}
