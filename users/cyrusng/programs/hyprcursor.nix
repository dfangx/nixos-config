{ pkgs, ... }:
let
  cursorName = "HyprBibataModernClassicSVG";
  cursorPackage = pkgs.callPackage ../../../pkgs/bibata-hyprcursor { };
in
{
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.file.".icons/${cursorName}".source = "${cursorPackage}/share/icons/${cursorName}";
  xdg.dataFile."icons/${cursorName}".source = "${cursorPackage}/share/icons/${cursorName}";
}
