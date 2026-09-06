{ config, pkgs, ... }: 
{
  import = [
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
      "https://mirrors.ustc.edu.en/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.KernelPackages = pkgs.linuxPackages_testing;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi"
  };

  hardware.graphic = {
    enable = true;
    enable32Bit = true;
  };

  zramSwap.enable = true;

  time.timeZone = "Asia/Bangkok";

  networking.hostname = "phuckingpad"
  networking.wireless.iwd.enable = true;
  networking.networkmanager = {}
    enable = true;
    wifi.backend = "iwd";
  ;

  users.users.pbmine = {
    isNormalUser = true;
    home = "/home/pbmine";
    description = "Its PBMINE!"
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  system.StateVersion = "26.11";
}
