{ config, lib, ... }:
{
  options.logind.enable = lib.mkEnableOption "Enable logind";
  config = lib.mkIf config.nix.enable {
    services = {
      logind = {
        killUserProcesses = true;
        powerKey = "suspend";
      };
    };
  };
}
