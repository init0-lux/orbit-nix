{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  electron,
  alsa-lib,
  mesa,
  libsecret,
  nss,
  nspr,
  xorg,
  dbus,
  at-spi2-core,
  cups,
  gtk3,
  pango,
  cairo,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "orbit";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/expo/orbit/releases/download/expo-orbit-v2.6.0/expo-orbit_${version}_amd64.deb";
    sha256 = "0hfnc69ac2mghbaazsk9vai7g5dzvpqjgan9akgm81bbbaxi12v3";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    mesa
    libsecret
    nss
    nspr
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    dbus
    at-spi2-core
    cups
    gtk3
    pango
    cairo
    libxkbcommon
  ];

  unpackPhase = "dpkg-deb -x $src . || true";

  installPhase = ''
    mkdir -p $out/bin $out/share $out/lib
    cp -r usr/share/* $out/share/
    cp -r usr/lib/expo-orbit $out/lib/

    # Make executable
    chmod +x $out/lib/expo-orbit/expo-orbit
    ln -s $out/lib/expo-orbit/expo-orbit $out/bin/orbit

    # Desktop Integration
    substituteInPlace $out/share/applications/expo-orbit.desktop \
      --replace /usr/lib/expo-orbit/expo-orbit $out/bin/orbit

    # Wrap the executable
    wrapProgram $out/bin/orbit \
      --set ELECTRON_NO_UPDATER 1
  '';

  meta = with lib; {
    description = "Expo Orbit - Nix-native packaging";
    homepage = "https://github.com/expo/orbit";
    platforms = [ "x86_64-linux" ];
  };
}
