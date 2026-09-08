{
  config,
  lib,
}: {
  "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "./niri/config.kdl";
}
