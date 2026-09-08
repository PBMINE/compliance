{config, ...}: let
  configs = "${config.home.homeDirectory}/compliance/system/users/pbmine/configs";
in {
  "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${configs}/niri/config.kdl";
}
