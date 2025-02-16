{ config, lib, ... }:
{
  options.xdgCfg.enable = lib.mkEnableOption "Enable xdg";
  config = lib.mkIf config.xdgCfg.enable {
    xdg = {
      enable = true;
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      userDirs = {
        enable = true;
        desktop = "${config.home.homeDirectory}/dt";
        documents = "${config.home.homeDirectory}/docs";
        download = "${config.home.homeDirectory}/dls";
        music = "${config.home.homeDirectory}/music";
        pictures = "${config.home.homeDirectory}/pics";
        videos = "${config.home.homeDirectory}/vids";
      };
      portal.xdgOpenUsePortal = true;
      portal.config.common.default = "*";
    };

    home = {
      sessionVariables = {
        GNUPGHOME = "${config.xdg.dataHome}/gnupg";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
        GOPATH = "${config.xdg.dataHome}/go";
        _JAVA_AWT_WM_NONREPARENTING = 1;
        XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";
      };

      sessionPath = [
        config.home.sessionVariables."XDG_BIN_HOME"
      ];

      activation.makeXdgUserDirs = lib.hm.dag.entryAfter ["${config.home.homeDirectory}"] ''
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots
      '';
    };
  };
}
