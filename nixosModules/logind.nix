{ config, lib, ... }:
{
  options.logind.enable = lib.mkEnableOption "Enable common users";
  config = lib.mkIf config.logind.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    services = {
      logind = {
        killUserProcesses = true;
        powerKey = "suspend";
      };
      sshd.enable = true;
    };
  };
}

