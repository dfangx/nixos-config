{ config, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "smtp.${hostName}.${domain}";
in
{
  environment.systemPackages = [
    pkgs.hydroxideNew
  ];

  systemd.services.hydroxide = {
    unitConfig = {
      Description = "Start hydroxide";
      After = "network-online.target";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide smtp";
      User = "hydroxide";
      Group = "hydroxide";
    };
  };
}




