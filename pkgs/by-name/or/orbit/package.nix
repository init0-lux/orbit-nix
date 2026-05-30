{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  nss,
  nspr,
  libsecret,
  xorg,
  dbus,
  at-spi2-core,
  cups,
  gtk3,
}:

let
  version = "2.6.0";
in
stdenv.mkDerivation {
  inherit version;
  pname = "orbit";

  src = fetchurl {
    url = "https://github.com/expo/orbit/releases/download/expo-orbit-v${version}/expo-orbit_${version}_amd64.deb";
    sha256 = "0hfnc69ac2mghbaazsk9vai7g5dzvpqjgan9akgm81bbbaxi12v3";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    nss
    nspr
    libsecret
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    dbus
    at-spi2-core
    cups
    gtk3
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin $out/share $out/lib
    cp -r usr/share/* $out/share/
    cp -r usr/lib/expo-orbit $out/lib/

    chmod +x $out/lib/expo-orbit/expo-orbit
    ln -s $out/lib/expo-orbit/expo-orbit $out/bin/orbit

    substituteInPlace $out/share/applications/expo-orbit.desktop \
      --replace /usr/lib/expo-orbit/expo-orbit $out/bin/orbit

    wrapProgram $out/bin/orbit \
      --set ELECTRON_NO_UPDATER 1
  '';

  disallowedReferences = [ dpkg ];

  passthru.updateScript = ../../../../scripts/update.sh;

  meta = with lib; {
    description = "Install and run React Native apps on Android devices and emulators";
    homepage = "https://github.com/expo/orbit";
    license = licenses.mit;
    maintainers = with maintainers; [ init0 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "orbit";
  };
}
