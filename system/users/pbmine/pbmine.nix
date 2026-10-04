{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  customQuickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.withModules [
    inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtmultimedia
    pkgs.kdePackages.qtimageformats
    pkgs.kdePackages.qtsvg
  ];
  makeSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in {
  home = {
    username = "pbmine";
    homeDirectory = "/home/pbmine";
    stateVersion = "26.11";
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    # Global Shell intergration

    shell = {
      enableFishIntegration = true;
    };
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
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    xwayland-satellite-unstable
    arduino-ide
  ];

  # Stylish Prompt
  programs.starship = {
    enable = true;
  };

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
    configs = {
      "shell.qml" = ./configs/quickshell/shell.qml;
      "Colors.qml" = ./configs/quickshell/Colors.qml;
    };
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

  # For matugen instant use, Only flake version of the package are used

  xdg.configFile = lib.mkMerge [
    {
      "matugen" = {
        source = makeSymlink "${config.home.homeDirectory}/compliance/system/users/pbmine/configs/matugen";
        recursive = true;
      };

      "niri" = {
        source = makeSymlink "${config.home.homeDirectory}/compliance/system/users/pbmine/configs/niri/niri-configs";
      };

      "ghostty/shaders" = {
        source = makeSymlink "${config.home.homeDirectory}/compliance/system/users/pbmine/configs/ghostty/shaders";
      };
    }
  ];
}
