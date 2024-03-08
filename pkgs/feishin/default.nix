{ pkgs, ... }:

pkgs.appimageTools.wrapType2 { # or wrapType1
  name = "feishin";
  src = pkgs.fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/v0.5.3/Feishin-0.5.3-linux-x86_64.AppImage";
    hash = "sha256-1JlsEBLVBaaae9NDGsGI5CyE+XcBunSt0CWQFpkL87w=";
  };
  extraPkgs = pkgs: with pkgs; [ mpv ];
}
