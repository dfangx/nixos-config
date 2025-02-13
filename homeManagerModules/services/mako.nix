{ config, lib, ... }:
{
  options.mako.enable = lib.mkEnableOption "Enable mako";
  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      backgroundColor = "#2e3440ff";
      font = "Source Code Pro for Powerline 12";
      format = "<b>%s</b>\\n%b";
      textColor = "#88c0d0ff";
      layer = "overlay";
      progressColor = "source #4c566aff";
      defaultTimeout = 3000;
      extraConfig = ''
        history=1
      '';
    };
  };
}
