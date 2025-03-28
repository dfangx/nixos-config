{ config, pkgs, lib, ... }:
{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./waybar.nix
    ../services/hypridle.nix
    ../services/hyprpaper.nix
  ];

  options.wayland.enable = lib.mkEnableOption "Enable wayland";

  config = lib.mkIf config.wayland.enable {
    hyprland.enable = lib.mkDefault true;
    hyprlock.enable = lib.mkDefault true;
    waybar.enable = lib.mkDefault true;
    hypridle.enable = lib.mkDefault true;
    hyprpaper.enable = lib.mkDefault true;

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
  };
}

