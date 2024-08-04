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
        "DP-2,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
        "DP-3,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      ];
    };
  };
}
