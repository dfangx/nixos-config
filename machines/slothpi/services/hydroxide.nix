{ config, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "smtp.${hostName}.${domain}";
in
{
  environment.systemPackages = [
    pkgs.hydroxide
  ];

  users = {
    users.hydroxide = {
      isSystemUser = true;
    };
    groups.hydroxide = { };
  };

  systemd.services.hydroxide = {
    enable = true;
    unitConfig = {
      Description = "Start hydroxide";
      After = "network-online.target";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
      User = "hydroxide";
      Group = "hydroxide";
    };
  };
}




