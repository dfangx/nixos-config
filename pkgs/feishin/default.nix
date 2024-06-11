{ pkgs, ... }:

pkgs.appimageTools.wrapType2 { # or wrapType1
  name = "feishin";
  src = pkgs.fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/v0.6.1/Feishin-0.6.1-linux-x86_64.AppImage";
    hash = "sha256-1MNSO9CSxoAHJ3F+oPWpz8/JW2nDcyPsLe/RFaQfwwE=";
  };
  extraPkgs = pkgs: with pkgs; [ mpv ];
}
