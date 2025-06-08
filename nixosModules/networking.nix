{ config, lib, host, ... }:
{
  options.netoworking.enable = lib.mkEnableOption "Enable networking";
  config = lib.mkIf config.nix.enable {
    networking = {
      hostName = host;
      wireless.iwd.enable = true;
    };
  };
}
