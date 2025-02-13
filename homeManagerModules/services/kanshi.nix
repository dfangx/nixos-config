{ config, lib,  ... }:
{
  options.kanshi.enable = lib.mkEnableOption "Enable kanshi";
  config = lib.mkIf config.kanshi.enable {
    services.kanshi = {
      enable = false;
      systemdTarget = "${config.home.sessionVariables.XDG_SESSION_DESKTOP}-session.target";
      profiles = {
        doubleMon = {
          outputs = [
            {
              criteria = "*";
              status = "enable";
            }
            {
              criteria = "*";
              status = "enable";
            }
          ];
        };
        singleMon = {
          outputs = [
            {
              criteria = "*";
              status = "enable";
            }
          ];
        };
        tripleMon = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "*";
              status = "enable";
            }
            {
              criteria = "*";
              status = "enable";
            }
          ];
        };
      };
    };
  };
}
