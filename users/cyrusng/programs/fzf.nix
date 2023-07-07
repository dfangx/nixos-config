{ config, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    tmux.enableShellIntegration = true;
    defaultCommand = "fd -H";
    defaultOptions = [
      "--color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#616e88,fg:#d8dee9,header:#616e88,info:#81a1c1,pointer:#81a1c1,marker:#81a1c1,fg+:#d8dee9,prompt:#81a1c1,hl+:#81a1c1"
      "--height=90%"
      "--info=inline"
      "--border"
    ];
    changeDirWidgetCommand = "fd -t d . ${config.home.homeDirectory}";
    fileWidgetCommand = config.programs.fzf.defaultCommand;
  };
}
