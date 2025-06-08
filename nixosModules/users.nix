{ config, lib, ... }:
{
  options.users.enable = lib.mkEnableOption "Enable users";
  config = lib.mkIf config.users.enable {
    users.users.cyrusng = {
      extraGroups = [ "input" "audio" "gamemode" ];
    };
  };
}
