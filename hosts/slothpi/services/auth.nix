{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "login.${hostName}.${domain}";
in
{
  imports = [ 
    ./auth/ldap.nix
    ./auth/authelia.nix
  ];
}
