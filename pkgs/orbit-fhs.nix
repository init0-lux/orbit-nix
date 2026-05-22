{
  lib,
  buildFHSEnv,
  orbit,
}:

buildFHSEnv {
  name = "orbit-fhs";
  targetPkgs =
    pkgs: with pkgs; [
      orbit
      android-tools
    ];
  runScript = "orbit";
}
