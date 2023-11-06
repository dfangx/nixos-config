{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "swaylock-fprintd";
  version = "1.7.2";

  src = pkgs.fetchFromGitHub {
    owner = "SL-RU";
    repo = "swaylock-fprintd";
    rev = "ffd639a785df0b9f39e9a4d77b7c0d7ba0b8ef79";
    hash = "sha256-2VklrbolUV00djPt+ngUyU+YMnJLAHhD+CLZD1wH4ww=";
  };

  postPatch = ''
  substituteInPlace fingerprint/meson.build --replace \
    '/usr/share/dbus-1/interfaces/net.reactivated.Fprint' \
    '${pkgs.fprintd}/share/dbus-1/interfaces/net.reactivated.Fprint'
  '';

  strictDeps = true;
  depsBuildBuild = with pkgs; [ pkg-config ];
  nativeBuildInputs = with pkgs; [
    pkg-config
    glib
    meson
    ninja
    scdoc
    wayland-scanner
  ];
  buildInputs = with pkgs; [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
    gdk-pixbuf
    pam
    dbus
  ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];
}

