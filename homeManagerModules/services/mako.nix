{ config, lib, ... }:
{
  options.mako.enable = lib.mkEnableOption "Enable mako";
  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        history = 1;
        background-color = "#2e3440ff";
        font = "Source Code Pro for Powerline 12";
        format = "<b>%s</b>\\n%b";
        text-color = "#88c0d0ff";
        layer = "overlay";
        progress-color = "source #4c566aff";
        default-timeout = 3000;
      };
    };
  };
}
