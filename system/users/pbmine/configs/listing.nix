{config, ...}: let
  configPath = "${config.home.homeDirectory}/compliance/system/users/pbmine/configs";
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    quickshell = "quickshell";
    alacritty = "alacritty";
  };
in
  builtins.mapAttrs (name: subPath: {
    source = createSymlink "${configPath}/${subPath}";
    recursive = true;
  })
  configs
