{ lib, config, pkgs, ... }: 
{
  home.username = "pbmine";
  home.homeDirectory = "/home/pbmine";
  home.stateVersion = "26.11";
  programs.git.enable = true;
}

