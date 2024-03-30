{ pkgs, lib, ... }:
{
  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./hyprlock.nix
    ../services/hypridle.nix
    ../services/hyprpaper.nix
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';

}

