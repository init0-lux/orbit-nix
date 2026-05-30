{
  lib,
  pkgs,
  ...
}:

{
  options.programs.orbit = {
    enable = lib.mkEnableOption "Expo Orbit";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.orbit;
      description = "The orbit package to use.";
    };
  };
}
