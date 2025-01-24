{ config, pkgs, lib, inputs, ... }:
let
  terminal = "${lib.getExe pkgs.alacritty}";
in
{
  imports = [
    inputs.ags.homeManagerModules.default
    ../desktop.nix
    ./programs/waybar.nix
    ./programs/hyprland.nix
    ./services/hydroxide.nix
    ./services/hyprpaper.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.9796"
  ];

  home = {
    packages = with pkgs; [
      lutris
      heroic
      protonup-qt
      wineWowPackages.unstable
      thunderbird
      googleearth-pro
      krita
      razergenie
    ];
  };

  programs.ags.enable = false;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
