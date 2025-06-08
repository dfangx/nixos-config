{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "people.${hostName}.${domain}";
in
{
  options.monica.enable = lib.mkEnableOption "Enable Monica";
  config = lib.mkIf config.monica.enable {
    age.secrets = {
      monica = {
        file = ../secrets/monica.age;
        owner = "monica";
      };
      laravel = {
        file = ../secrets/laravel.age;
        owner = "monica";
      };
    };

    services.monica = {
      enable = true;
      hostname = fqdn;
      appURL = fqdn;
      appKeyFile = config.age.secrets.laravel.path;
      database = {
        user = config.services.monica.user;
        # passwordFile = config.age.secrets.monica.path;
      };
      nginx = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
      };
    };
  };
}
