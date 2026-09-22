{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  customQuickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.withModules [
    inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtmultimedia
    pkgs.kdePackages.qtimageformats
    pkgs.kdePackages.qtsvg
  ];
in {
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
    btop
    krita
    opencode-desktop
    # Opencode DOES have HM but not right now!
    opencode
    rust-analyzer
    xwayland-satellite-unstable
    arduino-ide
  ];

  # A Window Manager
  programs.niri = import ./configs/niri/niri.nix {inherit pkgs lib;};

  # A wallpaper services
  services.awww.enable = true;

  # Declare Flatpak from modules
  services.flatpak = import ./configs/flatpak/flatpak.nix;

  # Temp lock-screen services (To be replace with quickshell)
  programs.swaylock.enable = true;

  # Enable OBS for recording!
  programs.obs-studio.enable = true;

  programs.nvf = {
    enable = true;
    # Import the settings instead of writing down here!
    settings = import ./configs/nvf/nvf.nix {inherit pkgs inputs;};
  };

  # Enable quickshell
  programs.quickshell = {
    enable = true;
    package = customQuickshell;
  };

  # Productivity APP
  programs.obsidian = {
    enable = true;

    vaults.notes.target = "Documents/Obsidian";

    defaultSettings.app = {
      alwaysUpdateLinks = true;
      spellcheck = true;
    };
  };

  programs.nixcord = import ./configs/nixcord/nixcord.nix;

  # a bunch of programs for user
  programs.git.enable = true;
  programs.prismlauncher.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    enableFishIntegration = true;
    settings = import ./configs/ghostty/ghostty.nix;
  };
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty -e";
      };
    };
  };
  xdg.configFile = import ./configs/linking.nix {inherit config;};
}
