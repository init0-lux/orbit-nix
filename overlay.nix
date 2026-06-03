final: prev: {
  expo-orbit-bin = final.callPackage ./pkgs/by-name/ex/expo-orbit-bin/package.nix { };

  # Backwards-compat alias (command remains `orbit`).
  orbit = final.expo-orbit-bin;
}
