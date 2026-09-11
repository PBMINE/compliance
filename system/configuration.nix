{pkgs, ...}: {
  imports = [
    ./hardware/hardware-configuration.nix
    ./disko/disk-config.nix
  ];

  nix.settings = {
    # Enabled Flake and it Required Command
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Add Chinese nix-channels location to speedup rebuilding for asian (Like ME!)
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  # Set nixpkgs to allow proprietary packages on nixpkgs
  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.kernelParams = ["drm.panic_screen=qr_code"];

  # Set NixOS to use Bleeding Edge kernel (eg rc.1,rc.2)
  boot.kernelPackages = pkgs.linuxPackages_testing;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.loader.efi = {
    efiSysMountPoint = "/boot";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.opencl
      vulkan-loader
    ];
  };

  zramSwap.enable = true;

  time.timeZone = "Asia/Bangkok";

  networking.hostName = "phuckpad";
  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  users.users.pbmine = {
    isNormalUser = true;
    home = "/home/pbmine";
    description = "Its PBMINE!";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # Global Services!
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # System-wide stylix
  stylix = import ./users/pbmine/configs/stylix/stylix.nix;

  # Flatpak for specfic app
  services.flatpak.enable = true;

  # Sound Services
  # Enable Real-Time access for pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  # Enable PAM for swaylock to work (Will be removed soon)
  security.pam.services.swaylock = {};

  #Programs require for home to work
  programs.niri.enable = true;
  programs.fish.enable = true;

  #Install Fonts (Doesnt find a way to do that with home-manager yet...)
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];

  # Install Steam
  programs.steam.enable = true;

  # Temporary only!!! (I'll find a way soon, I promise!!!)
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  system.stateVersion = "26.11";
}
