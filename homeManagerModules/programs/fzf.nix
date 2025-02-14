{ config, lib, ... }:
{
  options.fzf.enable = lib.mkEnableOption "Enable fzf";
  config = lib.mkIf config.fzf.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
      defaultCommand = "fd -H";
      defaultOptions = [
        "--height=90%"
        "--info=inline"
        "--border"
      ];
      changeDirWidgetCommand = "fd -t d . ${config.home.homeDirectory}";
      fileWidgetCommand = config.programs.fzf.defaultCommand;
    };
  };
}
