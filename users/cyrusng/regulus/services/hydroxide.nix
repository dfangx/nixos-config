{ config, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "smtp.${hostName}.${domain}";
in
{
  home.packages = [
    pkgs.hydroxide
  ];

  systemd.user.services.hydroxide = {
    Unit = {
      Description = "Start hydroxide";
      After = "network-online.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
    };
  };
}
