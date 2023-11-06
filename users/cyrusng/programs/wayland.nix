{ pkgs, lib, ... }:
{
  imports = [
    ./hyprland.nix
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    MOZ_ENABLE_WAYLAND = 1;
  };

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';

}

