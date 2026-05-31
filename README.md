# orbit-nix

Nix-native packaging for [Expo Orbit](https://github.com/expo/orbit) — the React Native app manager for Android devices and emulators.

## Installation

### Via Flakes (recommended)

Run directly (no install needed):

```bash
nix run github:init0-lux/orbit-nix
```

Or install to your profile:

```bash
nix profile install github:init0-lux/orbit-nix
```

Or add to your flake inputs:

```nix
{
  inputs.orbit-nix.url = "github:init0-lux/orbit-nix";

  outputs = { self, nixpkgs, orbit-nix, ... }: {
    nixosConfigurations.YOUR_HOST = nixpkgs.lib.nixosSystem {
      modules = [
        orbit-nix.nixosModules.default
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ orbit-nix.overlays.default ];
          programs.orbit.enable = true;
        })
      ];
    };
  };
}
```

### Via Home Manager

```nix
{
  inputs.orbit-nix.url = "github:init0-lux/orbit-nix";

  outputs = { self, nixpkgs, home-manager, orbit-nix, ... }: {
    homeConfigurations.YOUR_USER = home-manager.lib.homeManagerConfiguration {
      modules = [
        orbit-nix.homeManagerModules.default
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ orbit-nix.overlays.default ];
          programs.orbit.enable = true;
        })
      ];
    };
  };
}
```

### FHS Variant

The default package (`orbit-fhs`) runs Orbit inside a `buildFHSEnv` with:
- Android SDK integration (`ANDROID_HOME`, `ANDROID_SDK_ROOT`, `PATH`)
- OpenGL/EGL libraries for Electron's GPU process
- Android emulator shared library support

If you want the standard (non-FHS) package:

```bash
nix run github:init0-lux/orbit-nix#orbit
```

## Configuration

Both the NixOS and Home Manager modules expose the same options:

```nix
programs.orbit = {
  enable = true;
  package = pkgs.orbit; # or pkgs.orbit-fhs
};
```

## Android SDK

Orbit requires Android SDK tools. The FHS variant (`orbit-fhs`) bundles `android-tools`. For the standard package, ensure `adb` is available in `PATH` and `ANDROID_HOME` is set if you use a custom SDK location.

## Supported Platforms

- `x86_64-linux`
- `aarch64-linux` is not yet supported (upstream does not publish aarch64 `.deb` builds).

## Updating

The package tracks [Expo Orbit releases](https://github.com/expo/orbit/releases). An automated update pipeline checks for new releases daily and opens a PR when one is found.
