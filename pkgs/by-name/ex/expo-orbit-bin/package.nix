{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  nss,
  nspr,
  libsecret,
  alsa-lib,
  mesa,
  libdrm,
  libxdamage,
  libxext,
  libxfixes,
  dbus,
  at-spi2-core,
  cups,
  gtk3,
}:

let
  version = "2.6.0";

  # For Nixpkgs: if/when you add yourself to nixpkgs' maintainers list,
  # you can switch this to `with maintainers; [ "init0-lux" ];` style.
  maintainer =
    lib.maintainers."init0-lux" or {
      name = "init0-lux";
      email = "init0.lux@protonmail.com";
      github = "init0-lux";
    };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "expo-orbit-bin";

  src = fetchurl {
    url = "https://github.com/expo/orbit/releases/download/expo-orbit-v${version}/expo-orbit_${version}_amd64.deb";
    hash = "sha256-Y4sQu1prBVTfVMmqJ/Hdv5V3otpp6q/Ugq8KppJh1kE=";
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
    alsa-lib
    mesa
    libdrm
    libxdamage
    libxext
    libxfixes
    dbus
    at-spi2-core
    cups
    gtk3
  ];

  dontBuild = true;

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions";

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
    maintainers = [ maintainer ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "orbit";
  };
}
