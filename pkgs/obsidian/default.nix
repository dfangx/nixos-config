{ pkgs, ... }:

pkgs.appimageTools.wrapType2 { # or wrapType1
  name = "obsidian";
  src = pkgs.fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage";
    hash = "sha256-1JlsEBLVBaaae9NDGsGI5CyE+XcBunSt0CWQFpkL87w=";
  };
  extraPkgs = pkgs: with pkgs; [ mpv ];
}
