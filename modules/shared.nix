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
      default = pkgs.expo-orbit-bin;
      description = "The Expo Orbit package to use.";
    };
  };
}
