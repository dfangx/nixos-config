{ config, ... }:
{
  services.hyprpaper = {
    settings = {
      wallpaper = [
        ",${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      ];
    };
  };
}

