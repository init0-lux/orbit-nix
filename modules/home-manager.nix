{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.orbit;
in
{
  options.programs.orbit = {
    enable = mkEnableOption "Expo Orbit";
    package = mkOption {
      type = types.package;
      default = pkgs.orbit;
      description = "The orbit package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
