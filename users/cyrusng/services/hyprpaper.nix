{ config, inputs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      preload = [
        "${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      ];
      wallpaper = [
        "eDP-1,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      ];
    };
  };
}
