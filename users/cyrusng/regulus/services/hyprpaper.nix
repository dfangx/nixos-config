{ config, ... }:
{
  services.hyprpaper = {
    settings = {
      wallpaper = [
        "DP-1,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
        "DP-2,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      ];
    };
  };
}

