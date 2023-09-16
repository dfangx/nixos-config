{ config, pkgs, ... }:

{
  networking = {
    firewall = {
      allowedUDPPorts = [ config.services.blocky.settings.port ];
      allowedTCPPorts = [ config.services.blocky.settings.port ];
    };
  };

  services = {
    grafana = {
      declarativePlugins = with pkgs.grafanaPlugins; [
        grafana-piechart-panel
      ];
      settings.panels.disable_sanitize_html = true;
    };

    prometheus = {
      scrapeConfigs = [
        {
          job_name = "blocky";
          static_configs = [
            {
              targets = [ config.services.blocky.settings.httpPort ];
            }
          ];
        }
      ];
    };

    blocky = {
      enable = true;
      settings = {
        prometheus.enable = true;
        httpPort = "127.0.0.1:4000";
        port = 53;
        logLevel = "warn";
        upstream.default = [
          "${config.services.unbound.settings.server.interface}:${toString config.services.unbound.settings.server.port}"
        ];
        caching = {
          minTime = "1h";
          maxTime = "24h";
          prefetching = true;
        };
        blocking = {
          startStrategy = "fast";
          blackLists = {
            tracking = [
              "https://v.firebog.net/hosts/Easyprivacy.txt"
              "https://v.firebog.net/hosts/Prigent-Ads.txt"
              "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
              "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
              "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
              "https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt"
              "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt"
              "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt"
              "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt"
              "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt"
            ];
            suspicious = [
              "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
              "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
              "https://v.firebog.net/hosts/static/w3kbl.txt"
              "https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt"
              "https://someonewhocares.org/hosts/zero/hosts"
              "https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts"
              "https://winhelp2002.mvps.org/hosts.txt"
              "https://v.firebog.net/hosts/neohostsbasic.txt"
              "https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt"
              "https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt"
            ];
            malicious = [
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
              "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt"
              "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"
              "https://v.firebog.net/hosts/Prigent-Crypto.txt"
              "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
              "https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt"
              "https://phishing.army/download/phishing_army_blocklist_extended.txt"
              "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
              "https://v.firebog.net/hosts/RPiList-Malware.txt"
              "https://v.firebog.net/hosts/RPiList-Phishing.txt"
              "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
              "https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts"
              "https://urlhaus.abuse.ch/downloads/hostfile/"
              "https://malware-filter.gitlab.io/malware-filter/phishing-filter-hosts.txt"
              "https://v.firebog.net/hosts/Prigent-Malware.txt"
            ];
            other = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
              "https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list"
              "https://v.firebog.net/hosts/Prigent-Adult.txt"
            ];
            ads = [
              "https://adaway.org/hosts.txt"
              "https://v.firebog.net/hosts/AdguardDNS.txt"
              "https://v.firebog.net/hosts/Admiral.txt"
              "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
              "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
              "https://v.firebog.net/hosts/Easylist.txt"
              "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
              "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
              "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
              "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
            ];
            # regex = [
            #   "/^ad([sxv]?[0-9]*|system)[_.-]([^.[:space:]]+\.){1,}|[_.-]ad([sxv]?[0-9]*|system)[_.-]/"
            #   "/^(.+[_.-])?adse?rv(er?|ice)?s?[0-9]*[_.-]/"
            #   "/^(.+[_.-])?telemetry[_.-]/"
            #   "/^adim(age|g)s?[0-9]*[_.-]/"
            #   "/^adtrack(er|ing)?[0-9]*[_.-]/"
            #   "/^advert(s|is(ing|ements?))?[0-9]*[_.-]/"
            #   "/^aff(iliat(es?|ion))?[_.-]/"
            #   "/^analytics?[_.-]/"
            #   "/^banners?[_.-]/"
            #   "/^beacons?[0-9]*[_.-]/"
            #   "/^count(ers?)?[0-9]*[_.-]/"
            #   "/^mads\./"
            #   "/^pixels?[-.]/"
            #   "/^stat(s|istics)?[0-9]*[_.-]/"
            # ];
          };
          clientGroupsBlock.default = [
            "ads"
            "other"
            "malicious"
            "suspicious"
            "tracking"
          ];
        };
      };
    };
  };
}
