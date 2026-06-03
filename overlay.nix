final: prev: {
  expo-orbit-bin = final.callPackage ./pkgs/by-name/ex/expo-orbit-bin/package.nix { };

  orbit = final.callPackage ./pkgs/by-name/or/orbit/package.nix { };
}
