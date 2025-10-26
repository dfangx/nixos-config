{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
in
{
  options.homepage-dashboard.enable = lib.mkEnableOption "Enable homepage-dashboard";
  config = lib.mkIf config.homepage-dashboard.enable {
    services = {
      homepage-dashboard = {
        enable = true;
        allowedHosts = "${fqdn},localhost,127.0.0.1:${toString config.services.homepage-dashboard.listenPort},192:168.2.2:${toString config.services.homepage-dashboard.listenPort}";
        listenPort = 34651;
        openFirewall = true;
        services = [
          {
            System = [
              {
                "System Info" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "info";
                    version = 4;
                  };
                };
              }
              {
                "CPU Usage" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "cpu";
                    version = 4;
                  };
                };
              }
              {
                "Memory Usage" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "memory";
                    version = 4;
                  };
                };
              }
              {
                "Processes" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "process";
                    version = 4;
                  };
                };
              }
              {
                "Network Usage" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "network:end0";
                    version = 4;
                  };
                };
              }
              {
                "CPU Temperature" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "sensors:cpu_thermal 0";
                    version = 4;
                  };
                };
              }
              {
                "Root" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "fs:/";
                    version = 4;
                    chart = false;
                  };
                };
              }
              {
                "Data" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${toString config.services.glances.port}";
                    metric = "fs:/srv";
                    version = 4;
                    chart = false;
                  };
                };
              }
            ];
          }
          {
            Media = [
              {
                "Music" = {
                  href = "https://music.slothpi.duckdns.org";
                  description = "Navidrome";
                  widget = {
                    type = "navidrome";
                    url = "http://localhost:${toString config.services.navidrome.settings.Port}";
                    user = "cyrusng";
                    salt = "zIENure4lwbjr";
                    token = "44e7e2f6cd16a58fd444caaa91add8fe";
                    version = 4;
                  };
                };
              }
              {
                "Pictures" = {
                  href = "https://pictures.slothpi.duckdns.org";
                  description = "Immich";
                  widget = {
                    type = "immich";
                    url = "http://localhost:${toString config.services.immich.port}";
                    key = "IQ8eZEWbECxbjHDrDAwlStBnN5Sq2ToCgEcLOL01tY";
                    version = 2;
                  };
                };
              }
            ];
          }
        ];
        widgets = [
          {
            datetime = {
              text_size = "2x1";
              format = {
                dateStyle = "long";
                timeStyle = "short";
                hourCycle = "h23";
              };
            };
          }
          {
            greeting = {
              text_size = "xl";
              text = "Welcome!";
            };
          }
          {
            openmeteo = {
              units = "metric";
              cache = 5;
              format.maximumFractionDigits = 1;
            };
          }
        ];
      };
      nginx = {
        virtualHosts."${fqdn}" = {
          # enableACME = true;
          useACMEHost = "${hostName}.${domain}";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.homepage-dashboard.listenPort}/";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;

                ##############################
                # authentik-specific config
                ##############################
                auth_request     /outpost.goauthentik.io/auth/nginx;
                error_page       401 = @goauthentik_proxy_signin;
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header       Set-Cookie $auth_cookie;

                # translate headers from the outposts back to the actual upstream
                auth_request_set $authentik_username $upstream_http_x_authentik_username;
                auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
                auth_request_set $authentik_entitlements $upstream_http_x_authentik_entitlements;
                auth_request_set $authentik_email $upstream_http_x_authentik_email;
                auth_request_set $authentik_name $upstream_http_x_authentik_name;
                auth_request_set $authentik_uid $upstream_http_x_authentik_uid;

                proxy_set_header X-authentik-username $authentik_username;
                proxy_set_header X-authentik-groups $authentik_groups;
                proxy_set_header X-authentik-entitlements $authentik_entitlements;
                proxy_set_header X-authentik-email $authentik_email;
                proxy_set_header X-authentik-name $authentik_name;
                proxy_set_header X-authentik-uid $authentik_uid;
              '';
              recommendedProxySettings = false;
            };
            # all requests to /outpost.goauthentik.io must be accessible without authentication
            "/outpost.goauthentik.io" = {
              # When using the embedded outpost, use:
              proxyPass = "http://127.0.0.1:9000/outpost.goauthentik.io";
              extraConfig = ''
                # Note: ensure the Host header matches your external authentik URL:
                proxy_set_header        Host $host;
                proxy_set_header        X-Original-URL $scheme://$http_host$request_uri;
                add_header              Set-Cookie $auth_cookie;
                auth_request_set        $auth_cookie $upstream_http_set_cookie;
                proxy_pass_request_body off;
                proxy_set_header        Content-Length "";
              '';
              recommendedProxySettings = false;
            };

            # Special location for when the /auth endpoint returns a 401,
            # redirect to the /start URL which initiates SSO
            "@goauthentik_proxy_signin" = {
              extraConfig = ''
                internal;
                add_header Set-Cookie $auth_cookie;
                return 302 /outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri;
              '';
              recommendedProxySettings = false;
            };
          };
        };
      };
    };
  };
}

