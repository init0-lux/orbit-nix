{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.orbit;
in
{
  imports = [ ./shared.nix ];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isx86_64;
        message = "Expo Orbit only supports x86_64-linux";
      }
    ];

    home.packages = [ cfg.package ];
  };
}
