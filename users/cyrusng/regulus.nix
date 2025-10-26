{ pkgs, inputs, ... }:
{
  imports = [
    ./common.nix
  ];

  desktop.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
  ];

  home = {
    packages = let
      qS = inputs.quickshell.packages.x86_64-linux.default.override {
        withX11 = false;
      };
    in
    with pkgs; [
      lutris
      heroic
      protonup-qt
      wineWowPackages.waylandFull
      thunderbird
      krita
      immich-machine-learning
      hexchat
      qS
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

xdg.configFile."quickshell/shell.qml".source = ./quickshell/shell.qml;
}
