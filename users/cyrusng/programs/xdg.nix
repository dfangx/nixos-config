{ config, pkgs, lib, ... }:
{
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    userDirs = {
      desktop = "${config.home.homeDirectory}/dt";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dls";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pics";
      videos = "${config.home.homeDirectory}/vids";
    };
  };

  home.activation.makeXdgUserDirs = lib.hm.dag.entryAfter ["${config.home.homeDirectory}"] ''
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots
  '';
}
