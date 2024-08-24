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

  home = {
    packages = with pkgs; [
      lutris
      heroic
      protonup-qt
      wineWowPackages.full
      thunderbird
    ];
  };

  programs.ags.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
