{
  lib,
  buildFHSEnv,
  orbit,
}:

buildFHSEnv {
  name = "orbit-fhs";
  targetPkgs =
    pkgs: with pkgs; [
      # Wrapper that sets up Android SDK environment and LD_LIBRARY_PATH
      # so that Orbit and subprocesses like the emulator can find
      # shared libraries (libGL, zlib, etc.).
      (writeShellScriptBin "orbit-fhs-wrapper" ''
        ANDROID_HOME="$HOME/Android/Sdk"
        ANDROID_SDK_ROOT="$ANDROID_HOME"

        if [ -d "$ANDROID_HOME" ]; then
          export ANDROID_HOME
          export ANDROID_SDK_ROOT
          export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"
        fi

        # Make FHS libraries discoverable by subprocesses (e.g. emulator)
        export LD_LIBRARY_PATH="/usr/lib:/usr/lib/x86_64-linux-gnu:/lib:/lib64''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

        exec orbit "$@"
      '')
      orbit
      android-tools
      # OpenGL/EGL libraries for Electron GPU process
      libGL
      libglvnd
      # Required by Android emulator and system images
      zlib
      libx11
      libxext
      libxcb
      libxau
      libxdmcp
      libpulseaudio
      ncurses
    ];
  runScript = "orbit-fhs-wrapper";
}
