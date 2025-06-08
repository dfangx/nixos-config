{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  options.nixvim.enable = lib.mkEnableOption "Enable nixvim";

  config = lib.mkIf config.nixvim.enable {
    home.packages = with pkgs; [
      nano
      # nerdfonts # For neorg
    ];

    programs.nixvim = ./nixvim-config.nix;
  };
}
