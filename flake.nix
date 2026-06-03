{
  description = "Nix-native packaging and distribution layer for Expo Orbit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      overlays.default = import ./overlay.nix;
      nixosModules.default = import ./modules/nixos.nix;
      homeManagerModules.default = import ./modules/home-manager.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        packages = {
          default = pkgs.callPackage ./pkgs/orbit-fhs.nix { inherit (pkgs) orbit; };
          orbit = pkgs.callPackage ./pkgs/by-name/or/orbit/package.nix { };
          expo-orbit-bin = pkgs.callPackage ./pkgs/by-name/ex/expo-orbit-bin/package.nix { };
          orbit-fhs = pkgs.callPackage ./pkgs/orbit-fhs.nix { inherit (pkgs) orbit; };
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
