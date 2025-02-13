{ config, lib, ... }:
{
  options.gammastep.enable = lib.mkEnableOption "Enable gammastep";
  config = lib.mkIf config.gammastep.enable {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };
}
