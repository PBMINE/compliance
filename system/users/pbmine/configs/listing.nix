{config}: let
  Configs = "${config.home.homeDirectory}/compliance/system/users/pbmine/configs";
in {
  "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${Configs}/niri/config.kdl";
}
