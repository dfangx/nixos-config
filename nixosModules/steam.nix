{ config, pkgs, lib, inputs, host, ... }:
{
  options.steam.enable = lib.mkEnableOption "Enable steam";
  config = lib.mkIf config.steam.enable {
    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        platformOptimizations.enable = true;
      };

      gamescope = {
        enable = true;
        capSysNice = false;
        args = [
          "--rt"
          "--hdr-enabled"
          "--adaptive-sync"
        ];
      };

      gamemode.enable = true;
    };

    services = {
      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-cpp;
        extraRules = [
          {
            "name" = "gamescope";
            "nice" = -20;
          }
        ];
      };
    };
  };
}

