{ config, inputs, ... }:
{
  imports = [
    inputs.hyprpaper.homeManagerModules.default
  ];

  services.hyprpaper = {
    enable = true;
    ipc = true;
    preloads = [
      "${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
    ];
    wallpapers = [
      "DP-2,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
      "DP-3,${config.xdg.userDirs.pictures}/wallpapers/20180616_100824.jpg"
    ];
  };
}
