{
  lib,
  pkgs,
  ...
}: {
  settings = {
    xwayland-satellite = {
      path = "${lib.getExe pkgs.xwayland-satellite-unstable}";
    };
  };

  config = null;
}
