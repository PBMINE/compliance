{ config, pkgs, ... }: 
{
  imports = [
    ./hardware/hardware-configuration.nix
    ./disko/disk-config.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

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
    wirepluber.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };  

  #Programs require for home to work  
  programs.niri.enable = true;
  programs.fish.enable = true;

  # TEMP
  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
 
  system.stateVersion = "26.11";
}
