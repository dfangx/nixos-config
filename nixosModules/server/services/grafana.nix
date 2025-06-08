{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "dashboards.${hostName}.${domain}";
in
{
  options.grafana.enable = lib.mkEnableOption "Enable Grafana";
  config = lib.mkIf config.grafana.enable {
    age.secrets = {
      grafanaAdmin = {
        file = ../secrets/grafanaAdmin.age;
        mode = "400";
        owner = "grafana";
        group = "grafana";
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 9090 ];
      };
    };

    services = {
      nginx.virtualHosts."${fqdn}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.grafana.settings.server.http_port}";
      };
      grafana = {
        enable = true;
        settings = {
          server = {
            http_port = 3000;
            http_addr = "127.0.0.1";
          };
          security = {
            admin_user = "cyrusng";
            admin_password = "$__file{${config.age.secrets.grafanaAdmin.path}}";
          };
        };
        provision = {
          datasources.settings ={
            apiVersion = 1;
            deleteDatasources = [
              {
                name = "Prometheus";
                orgId = 1;
              }
            ];
            datasources = [
              {
                name = "Prometheus";
                type = "prometheus";
                access = "proxy";
                orgId = 1;
                url = "http://127.0.0.1:${toString config.services.prometheus.port}";
                isDefault = true;
                version = 1;
                editable = true;
                securejsonData = {
                  graphiteVersion = "1.1";
                  tlsAuth = false;
                  tlsAuthWithCert = false;
                };
              }
            ];
          };
        };
      };

      prometheus = {
        enable = true;
        port = 9090;
        globalConfig = {
          scrape_interval = "15s";
          evaluation_interval = "15s";
        };
        exporters = {
          node = {
            enable = true;
            listenAddress = "127.0.0.1";
            port = 9100;
            enabledCollectors = [
              "systemd"
              "processes"
            ];
          };
        };
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [ "127.0.0.1:9100" ];
              }
            ];
          }
        ];
      };
    };
  };
}
