{ config, lib, ... }:
{
  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper = {
      settings = {
        wallpaper = [
          ",${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
          # ", ${config.xdg.userDirs.pictures}/wallpapers/IMG_20221011_131105.jpg"
        ];
      };
    };
  };
}

