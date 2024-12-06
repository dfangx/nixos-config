{ config, lib, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      preload = [
        "${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      ];
    };
  };
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
}
