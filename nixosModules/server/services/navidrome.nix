{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "music.${hostName}.${domain}";
in
{
  options.navidrome.enable = lib.mkEnableOption "Enable navidrome";
  config = lib.mkIf config.navidrome.enable {
    services = {
      navidrome = {
        enable = true;
        settings = {
          MusicFolder = "/srv/nfs/music";
          Port = 4533;
          DefaultTheme = "Nord";
          LastFM = {
            ApiKey = "a8d8d142450b9342682f5fc5599d2b6a";
            Secret = "f3d869d8784379d2feccebb8bc629a19";
          };
          Backup = {
            Path = "/var/lib/navidrome/backups";
            Count = 7;
            Schedule = "00 01 * * *";    # Backup every day at 01:00
          };
          ReverseProxyUserHeader = "X-authentik-username";
          ReverseProxyWhitelist = "0.0.0.0/0";
        };
      };

      nginx = {
        virtualHosts."${fqdn}" = {
          # enableACME = true;
          useACMEHost = "${hostName}.${domain}";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.navidrome.settings.Port}/";
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

    users = {
      users.navidrome = {
        isSystemUser = true;
        extraGroups = [ "music" ];
      };
      groups.music = { };
    };

    system.activationScripts.makeMusicDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${config.services.navidrome.settings.MusicFolder}
      chown nextcloud:music ${config.services.navidrome.settings.MusicFolder}
      chmod 770 ${config.services.navidrome.settings.MusicFolder}
    '';
  };
}
