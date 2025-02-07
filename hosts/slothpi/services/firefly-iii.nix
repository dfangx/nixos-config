{ config, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "finance.${hostName}.${domain}";
in
{
  age.secrets = {
    fireflyIII = {
      file = ../secrets/fireflyIII.age;
      mode = "770";
      owner = "firefly-iii";
      group = "nginx";
    };
  };

  services.firefly-iii = {
    enable = true;
    appURL = "https://${fqdn}";
    appKeyFile = config.age.secrets.fireflyIII.path;
    hostname = fqdn;
    nginx = {
      useACMEHost = "${hostName}.${domain}";
      forceSSL = true;
    };
    group = "nginx";
    database.createLocally = true;
  };

  services.nginx.virtualHosts."${fqdn}" = {
    locations."/data-importer/".proxyPass = "http://localhost:62375";
  };

  virtualisation.oci-containers.containers ={
    firefly-iii-data-importer = {
      image = "fireflyiii/data-importer:latest";
      ports = [ 
        "62375:8080" 
      ];
      environment = {
        FIREFLY_III_ACCESS_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZGZmYzYzMTE0MjY0MzVlMmQwYmQyYjJiMGYwMGU0YWFlY2ZhY2ZmNmQ5ZWNjNjYzZWRiMGFiZWY5ZmEwN2ZjOGViYTliMDU0Yjc0YTUyYTgiLCJpYXQiOjE2Nzc5OTE4NjAuNDQ5NjAyLCJuYmYiOjE2Nzc5OTE4NjAuNDQ5NjA5LCJleHAiOjE3MDk2MTQyNjAuMzY5NzYxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.DhTVUw40brCrAMhdH0qV3yIj6AAI-3K2C-Ovvl6-oo8G8tTtmBEnEpriqiV19qnOj4rP4lZnhTtE0EqQPHUBdGFYjso0xfnRrAfzt8hktKf8WvkUf63cCjobOS7viNhzO29U9brX7L1CuXOT9AJ9jpQLbpep4Kat-mj5wM6VruPSujeb-bhE2f3XsVnyonmNYwynMLAW53LNL-SsX8cKDF1Nolue_Hywe-yvkqxxjvC6Lv7YNCmVLllo5mv_62pVEfFzIhVMGgA6ZZnOA-761PSIrPQTR_b35sJmbuEnrybiEzvJzRKRGQeZq4YpczjzJooHjL_8n8RvQ622XAo-e0Cg0FGD1mqiaE6w5Xz52monGStR-jZskXJd1dXA4_dlb-wuLx10jsHrRpNhxPf8MG6o0a5JDzjDGx6BmdWe0o767iSBExkdbMUv4iraer_aqpR-EjYJmmxZPVim36XCt5RK884XcnhXTFSAya0cmYV1I3F8RrA-ytLAEO-XaYMRezGD5t79YnpNQjoU6lcEJbXTncDzzwnjtvlS2SAOF7djHK9GWw4v_mGYjwsLOWbeYQVMdIpsqx-l7DQfPuDV40M5WAUFD-Ac2tgdg_O5KVpQYliMFn2oGNs6Z2N0JnhH3nmboCJvfX6AOpV9YAY5Xj3ff4uJOwAGtKm5GXXRDZE";
        FIREFLY_III_URL = "https://finance.slothpi.duckdns.org";
        TRUSTED_PROXIES = "**";
      };
      extraOptions = [
        "--dns=192.168.0.116"
      ];
    };
  };
}

