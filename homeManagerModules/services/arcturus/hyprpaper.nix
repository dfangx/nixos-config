{ config, lib, ... }:
{
  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper = {
      settings = {
        wallpaper = [
          "eDP-1,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
        ];
      };
    };
  };
}


