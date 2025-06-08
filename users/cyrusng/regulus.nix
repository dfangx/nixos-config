{ pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  desktop.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
  ];

  home = {
    packages = with pkgs; [
      lutris
      heroic
      protonup-qt
      wineWowPackages.waylandFull
      thunderbird
      krita
      immich-machine-learning
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
