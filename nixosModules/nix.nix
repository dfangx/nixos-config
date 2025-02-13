{ config, lib, ... }:
{
  options.nix.enable = lib.mkEnableOption "Enable nix";
  config = lib.mkIf config.nix.enable {
    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
        min-free = ${toString (1024 * 1024 * 1024)}
      '';
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        auto-optimise-store = true;
        trusted-users = [ "cyrusng" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
}
